//
//  NSObject+Night.m
//  DKNightVersion
//
//  Created by Draveness on 15/11/7.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "NSObject+Night.h"
#import "NSObject+DeallocBlock.h"
#import <objc/runtime.h>

static void *DKViewDeallocHelperKey;

@interface NSObject ()

// 为每个对象添加一个私有pickers属性，用于存储 value:DKColorPicker对象、key:真正设置属性的方法名称
@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation NSObject (Night)

- (NSMutableDictionary<NSString *, DKColorPicker> *)pickers {
    NSMutableDictionary<NSString *, DKColorPicker> *pickers = objc_getAssociatedObject(self, @selector(pickers));
    // 判断pickers是否已经存在
    if (!pickers) {
        
        @autoreleasepool {
            // Need to removeObserver in dealloc
            if (objc_getAssociatedObject(self, &DKViewDeallocHelperKey) == nil) {
                __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc
                // deallocHelper 为DKDeallocBlockExecutor的实例对象
                id deallocHelper = [self addDeallocBlock:^{
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                }];
                // 以OBJC_ASSOCIATION_ASSIGN的策略进行存储，引用计数没有加1
                // 当调用了pickers方法的对象在销毁时，deallocHelper引用计数为0，将会执行dealloc方法，在dealloc中调用上面的移除通知block
                objc_setAssociatedObject(self, &DKViewDeallocHelperKey, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
        }

        // 创建字典pickers，并通过关联对象保存
        pickers = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(pickers), pickers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // 移除旧通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DKNightVersionThemeChangingNotification object:nil];

         // 为每个对象在第一次获取pickers时，添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(night_updateColor) name:DKNightVersionThemeChangingNotification object:nil];
    }
    return pickers;
}

- (DKNightVersionManager *)dk_manager {
    return [DKNightVersionManager sharedManager];
}

// 修改主题，通知调用方法
- (void)night_updateColor {
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, DKColorPicker  _Nonnull picker, BOOL * _Nonnull stop) {
        // 真正设置主题颜色的方法
        SEL sel = NSSelectorFromString(selector);
        // 调用picker这个block，传入当前主题，获取修改主题后的颜色
        id result = picker(self.dk_manager.themeVersion);
        // 修改主题颜色
        [UIView animateWithDuration:DKNightVersionAnimationDuration
                         animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [self performSelector:sel withObject:result];
#pragma clang diagnostic pop
                         }];
    }];
}

@end

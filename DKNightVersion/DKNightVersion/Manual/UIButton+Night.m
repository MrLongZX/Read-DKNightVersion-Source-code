//
//  UIButton+Night.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/9.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "UIButton+Night.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *pickers;

@end

@implementation UIButton (Night)

- (void)dk_setTitleColorPicker:(DKColorPicker)picker forState:(UIControlState)state {
    // 为按钮state下，设置当前主题的对应颜色
    [self setTitleColor:picker(self.dk_manager.themeVersion) forState:state];
    NSString *key = [NSString stringWithFormat:@"%@", @(state)];
    // 判断state下保存信息的字典是否已经存在
    NSMutableDictionary *dictionary = [self.pickers valueForKey:key];
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    // 保存 picker 、真正设置主题的方法 两个信息
    [dictionary setValue:[picker copy] forKey:NSStringFromSelector(@selector(setTitleColor:forState:))];
    // 获取NSObject+Night分类下为每个对象添加的pickers属性，将 picker 与 真正的赋值方法 保存
    [self.pickers setValue:dictionary forKey:key];
}

- (void)dk_setBackgroundImage:(DKImagePicker)picker forState:(UIControlState)state {
    [self setBackgroundImage:picker(self.dk_manager.themeVersion) forState:state];
    NSString *key = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary *dictionary = [self.pickers valueForKey:key];
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    [dictionary setValue:[picker copy] forKey:NSStringFromSelector(@selector(setBackgroundImage:forState:))];
    [self.pickers setValue:dictionary forKey:key];
}

- (void)dk_setImage:(DKImagePicker)picker forState:(UIControlState)state {
    [self setImage:picker(self.dk_manager.themeVersion) forState:state];
    NSString *key = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary *dictionary = [self.pickers valueForKey:key];
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    [dictionary setValue:[picker copy] forKey:NSStringFromSelector(@selector(setImage:forState:))];
    [self.pickers setValue:dictionary forKey:key];
}

// 复写NSObject+Night分类下修改主题通知调用的方法
- (void)night_updateColor {
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            // 按钮某UIControlState下的颜色、图片属性主题设置
            // 下面dictionary保存 设置属性的方法名 ： picker
            NSDictionary<NSString *, DKColorPicker> *dictionary = (NSDictionary *)obj;
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, DKColorPicker  _Nonnull picker, BOOL * _Nonnull stop) {
                UIControlState state = [key integerValue];
                [UIView animateWithDuration:DKNightVersionAnimationDuration
                                 animations:^{
                                     // 判断设置属性的方法名
                                     if ([selector isEqualToString:NSStringFromSelector(@selector(setTitleColor:forState:))]) {
                                         // 获取修改主题后的颜色
                                         UIColor *resultColor = picker(self.dk_manager.themeVersion);
                                         // 重新设置
                                         [self setTitleColor:resultColor forState:state];
                                     } else if ([selector isEqualToString:NSStringFromSelector(@selector(setBackgroundImage:forState:))]) {
                                         UIImage *resultImage = ((DKImagePicker)picker)(self.dk_manager.themeVersion);
                                         [self setBackgroundImage:resultImage forState:state];
                                     } else if ([selector isEqualToString:NSStringFromSelector(@selector(setImage:forState:))]) {
                                         UIImage *resultImage = ((DKImagePicker)picker)(self.dk_manager.themeVersion);
                                         [self setImage:resultImage forState:state];
                                     }
                                 }];
            }];
        } else {
            // 与NSObject+Night分类下night_updateColor方法逻辑一致
            // 按钮的颜色、图片属性主题设置，不对应某个UIControlState
            SEL sel = NSSelectorFromString(key);
            DKColorPicker picker = (DKColorPicker)obj;
            UIColor *resultColor = picker(self.dk_manager.themeVersion);
            [UIView animateWithDuration:DKNightVersionAnimationDuration
                             animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                 [self performSelector:sel withObject:resultColor];
#pragma clang diagnostic pop
                             }];

        }
    }];
}

@end

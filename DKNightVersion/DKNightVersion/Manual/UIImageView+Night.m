//
//  UIImageView+Night.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/10.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "UIImageView+Night.h"
#import "NSObject+Night.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *pickers;

@end

@implementation UIImageView (Night)

// 创建自带主题picker的imageview对象
- (instancetype)dk_initWithImagePicker:(DKImagePicker)picker {
    // 获取当前主题下图片，创建imageview对象
    UIImageView *imageView = [self initWithImage:picker(self.dk_manager.themeVersion)];
    imageView.dk_imagePicker = [picker copy];
    return imageView;
}

- (DKImagePicker)dk_imagePicker {
    return objc_getAssociatedObject(self, @selector(dk_imagePicker));
}

- (void)dk_setImagePicker:(DKImagePicker)picker {
    objc_setAssociatedObject(self, @selector(dk_imagePicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.image = picker(self.dk_manager.themeVersion);
    // 获取NSObject+Night分类下为每个对象添加的pickers属性，将 picker 与 真正的赋值方法 保存
    [self.pickers setValue:[picker copy] forKey:@"setImage:"];

}

- (DKAlphaPicker)dk_alphaPicker {
    return objc_getAssociatedObject(self, @selector(dk_alphaPicker));
}

- (void)dk_setAlphaPicker:(DKAlphaPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_alphaPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.alpha = picker(self.dk_manager.themeVersion);
    [self.pickers setValue:[picker copy] forKey:@"setAlpha:"];
}

// 复写NSObject+Night分类下修改主题通知调用的方法
- (void)night_updateColor {
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"setAlpha:"]) {
            // 透明度主题修改，透明度为CGFloat，基础类型对象
            DKAlphaPicker picker = (DKAlphaPicker)obj;
            CGFloat alpha = picker(self.dk_manager.themeVersion);
            [UIView animateWithDuration:DKNightVersionAnimationDuration
                             animations:^{
                                // 通过objc_msgSend调用方法
                                ((void (*)(id, SEL, CGFloat))objc_msgSend)(self, NSSelectorFromString(key), alpha);
                             }];
        } else {
            // 图片、背景颜色等主题修改，图片、背景颜色等为OC对象
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

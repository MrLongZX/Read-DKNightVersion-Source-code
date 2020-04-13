//
//  DKImage.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/10.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "DKImage.h"
#import "DKNightVersionManager.h"
#import "DKColorTable.h"

@implementation DKImage

// 部分逻辑与DKColor一致，可以先看DKColor
DKImagePicker DKImagePickerWithNames(NSString *normalName, ...) {
    NSArray<DKThemeVersion *> *themes = [DKColorTable sharedColorTable].themes;
    NSMutableArray<NSString *> *names = [[NSMutableArray alloc] initWithCapacity:themes.count];
    [names addObject:normalName];
    NSUInteger num_args = themes.count - 1;
    va_list names_list;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvarargs"
    va_start(names_list, num_args);
#pragma clang diagnostic pop
    for (NSUInteger i = 0; i < num_args; i++) {
        NSString *name = va_arg(names_list, NSString *);
        [names addObject:name];
    }
    va_end(names_list);

    return [DKImage pickerWithNames:names];
}

DKImagePicker DKImagePickerWithImages(UIImage *normalImage, ...) {
    NSArray<DKThemeVersion *> *themes = [DKColorTable sharedColorTable].themes;
    NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] initWithCapacity:themes.count];
    [images addObject:normalImage];
    NSUInteger num_args = themes.count - 1;
    va_list images_list;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvarargs"
    va_start(images_list, num_args);
#pragma clang diagnostic pop
    for (NSUInteger i = 0; i < num_args; i++) {
        UIImage *image = va_arg(images_list, UIImage *);
        [images addObject:image];
    }
    va_end(images_list);

    return [DKImage pickerWithImages:images];
}

+ (DKImagePicker)pickerWithNormalImage:(UIImage *)normalImage nightImage:(UIImage *)nightImage {
    // 断言 判断两个参数不能为空
    NSParameterAssert(normalImage);
    NSParameterAssert(nightImage);
    return ^(DKThemeVersion *themeVersion) {
        return [themeVersion isEqualToString:DKThemeVersionNight] ? nightImage : normalImage;
    };
}

// 不同主题返回一个图片对象
+ (DKImagePicker)pickerWithImage:(UIImage *)image {
    return ^(DKThemeVersion *themeVersion) {
        return image;
    };
}

+ (DKImagePicker)imageNamed:(NSString *)name {
    return [self pickerWithImage:[UIImage imageNamed:name]];
}

+ (DKImagePicker)pickerWithNames:(NSArray<NSString *> *)names {
    DKColorTable *colorTable = [DKColorTable sharedColorTable];
    // 断言 判断图片数量 与 主题数量 是否相等
    NSParameterAssert(names.count == colorTable.themes.count);
    return ^(DKThemeVersion *themeVersion) {
        NSUInteger index = [colorTable.themes indexOfObject:themeVersion];
        // 防止数组越界，返回普通主题下image
        if (index >= colorTable.themes.count) {
            return [UIImage imageNamed:names[[colorTable.themes indexOfObject:DKThemeVersionNormal]]];
        }
        // 取出对应主题下图片名称，创建image对象返回
        return [UIImage imageNamed:names[index]];
    };
}

+ (DKImagePicker)pickerWithImages:(NSArray<UIImage *> *)images {
    DKColorTable *colorTable = [DKColorTable sharedColorTable];
    // 断言 判断图片数量 与 主题数量 是否相等
    NSParameterAssert(images.count == colorTable.themes.count);
    return ^(DKThemeVersion *themeVersion) {
        NSUInteger index = [colorTable.themes indexOfObject:themeVersion];
        // 防止数组越界，返回普通主题下image
        if (index >= colorTable.themes.count) {
            return images[[colorTable.themes indexOfObject:DKThemeVersionNormal]];
        }
        // 取出对应主题下image对象返回
        return images[index];
    };
}

@end

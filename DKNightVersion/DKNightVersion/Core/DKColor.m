//
//  DKColor.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/9.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "DKColor.h"
#import "DKNightVersionManager.h"
#import "DKColorTable.h"

@implementation DKColor

DKColorPicker DKColorPickerWithRGB(NSUInteger normal, ...) {
    UIColor *normalColor = [UIColor colorWithRed:((float)((normal & 0xFF0000) >> 16))/255.0 green:((float)((normal & 0xFF00) >> 8))/255.0 blue:((float)(normal & 0xFF))/255.0 alpha:1.0];

    // 获取主题名称组成的数组
    NSArray<DKThemeVersion *> *themes = [DKColorTable sharedColorTable].themes;
    // 根据主题数量生成相应容量的可变数组
    NSMutableArray<UIColor *> *colors = [[NSMutableArray alloc] initWithCapacity:themes.count];
    // 保存第一个颜色对象
    [colors addObject:normalColor];
    NSUInteger num_args = themes.count - 1;
    // va_list 用于解决可变参数问题
    // 声明一个指向个数可变的参数列表指针变量 名为rgbs
    va_list rgbs;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvarargs"
    // 初始化rgbs变量，第二个参数不是 normal（可变参数的前一个参数），而是 num_args （可变参数的个数），有疑问
    va_start(rgbs, num_args);
#pragma clang diagnostic pop
    for (NSUInteger i = 0; i < num_args; i++) {
        // 获得当前指向的参数，并且根据参数类型（NSUInteger）将指针移动到后一个参数，（获取可变的参数）
        // va_arg 第一个参数：va_list类型变量 第二个参数：可变参数类型，交代指针的偏移量
        NSUInteger rgb = va_arg(rgbs, NSUInteger);
        UIColor *color = [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
        // 保存后续参数生成的颜色对象
        [colors addObject:color];
    }
    // 清空 rgbs
    va_end(rgbs);

    return ^(DKThemeVersion *themeVersion) {
        // 根据修改后主题，获取当前主题位置
        NSUInteger index = [themes indexOfObject:themeVersion];
        // 根据主题位置，获取该主题下的颜色对象
        return colors[index];
    };
}

DKColorPicker DKColorPickerWithColors(UIColor *normalColor, ...) {
    // 获取主题名称组成的数组
    NSArray<DKThemeVersion *> *themes = [DKColorTable sharedColorTable].themes;
    // 根据主题数量生成相应容量的可变数组
    NSMutableArray<UIColor *> *colors = [[NSMutableArray alloc] initWithCapacity:themes.count];
    // 保存第一个颜色对象
    [colors addObject:normalColor];
    NSUInteger num_args = themes.count - 1;
    va_list colors_list;
    // 消除警告 https://linfeng.xyz/2018/10/10/警告消除强迫症的选择/
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvarargs"
    va_start(colors_list, num_args);
#pragma clang diagnostic pop

    for (NSUInteger i = 0; i < num_args; i++) {
        // 获取第二、三..个颜色对象参数
        UIColor *color = va_arg(colors_list, UIColor *);
        // 保存后续颜色对象参数
        [colors addObject:color];
    }
    va_end(colors_list);

    return ^(DKThemeVersion *themeVersion) {
        // 根据修改后主题，获取当前主题位置
        NSUInteger index = [themes indexOfObject:themeVersion];
        // 根据主题位置，获取该主题下的颜色对象
        return colors[index];
    };
}

+ (DKColorPicker)pickerWithNormalColor:(UIColor *)normalColor nightColor:(UIColor *)nightColor {
    return ^(DKThemeVersion *themeVersion) {
        return [themeVersion isEqualToString:DKThemeVersionNormal] ? normalColor : nightColor;
    };
}

+ (DKColorPicker)colorPickerWithUIColor:(UIColor *)color {
    return ^(DKThemeVersion *themeVersion) {
        return color;
    };
}

+ (DKColorPicker)blackColor {
    return [self colorPickerWithUIColor:[UIColor blackColor]];
}

+ (DKColorPicker)darkGrayColor {
    return [self colorPickerWithUIColor:[UIColor darkGrayColor]];
}

+ (DKColorPicker)lightGrayColor {
    return [self colorPickerWithUIColor:[UIColor lightGrayColor]];
}

+ (DKColorPicker)whiteColor {
    return [self colorPickerWithUIColor:[UIColor whiteColor]];
}

+ (DKColorPicker)grayColor {
    return [self colorPickerWithUIColor:[UIColor grayColor]];
}

+ (DKColorPicker)redColor {
    return [self colorPickerWithUIColor:[UIColor redColor]];
}

+ (DKColorPicker)greenColor {
    return [self colorPickerWithUIColor:[UIColor greenColor]];
}

+ (DKColorPicker)blueColor {
    return [self colorPickerWithUIColor:[UIColor blueColor]];
}

+ (DKColorPicker)cyanColor {
    return [self colorPickerWithUIColor:[UIColor cyanColor]];
}

+ (DKColorPicker)yellowColor {
    return [self colorPickerWithUIColor:[UIColor yellowColor]];
}

+ (DKColorPicker)magentaColor {
    return [self colorPickerWithUIColor:[UIColor magentaColor]];
}

+ (DKColorPicker)orangeColor {
    return [self colorPickerWithUIColor:[UIColor orangeColor]];
}

+ (DKColorPicker)purpleColor {
    return [self colorPickerWithUIColor:[UIColor purpleColor]];
}

+ (DKColorPicker)brownColor {
    return [self colorPickerWithUIColor:[UIColor brownColor]];
}

+ (DKColorPicker)clearColor {
    return [self colorPickerWithUIColor:[UIColor clearColor]];
}

+ (DKColorPicker)colorPickerWithWhite:(CGFloat)white alpha:(CGFloat)alpha {
    return [self colorPickerWithUIColor:[UIColor colorWithWhite:white alpha:alpha]];
}

+ (DKColorPicker)colorPickerWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha {
    return [self colorPickerWithUIColor:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
}

+ (DKColorPicker)colorPickerWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [self colorPickerWithUIColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
}

+ (DKColorPicker)colorPickerWithCGColor:(CGColorRef)cgColor {
    return [self colorPickerWithUIColor:[UIColor colorWithCGColor:cgColor]];
}

+ (DKColorPicker)colorPickerWithPatternImage:(UIImage *)image {
    return [self colorPickerWithUIColor:[UIColor colorWithPatternImage:image]];
}

#if __has_include(<CoreImage/CoreImage.h>)
+ (DKColorPicker)colorPickerWithCIColor:(CIColor *)ciColor NS_AVAILABLE_IOS(5_0) {
    return [self colorPickerWithUIColor:[UIColor colorWithCIColor:ciColor]];
}
#endif

@end


//
//  UISearchBar+Keyboard.m
//  DKNightVersion
//
//  Created by Draveness on 6/8/16.
//  Copyright © 2016 Draveness. All rights reserved.
//

#import "UISearchBar+Keyboard.h"
#import "NSObject+Night.h"
#import <objc/runtime.h>

@interface NSObject ()

- (void)night_updateColor;

@end

@implementation UISearchBar (Keyboard)

// 编译时期，加载此分类时，调用
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 方法交换
        Class class = [self class];

        SEL originalSelector = @selector(init);
        SEL swizzledSelector = @selector(dk_init);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });

}

- (instancetype)dk_init {
    // 调用原生init方法
    UISearchBar *obj = [self dk_init];
    // 支持键盘在暗黑主题下显示暗黑模式 && 目前为暗黑主题
    if (self.dk_manager.supportsKeyboard && [self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        // 修改键盘为暗黑模式
#if defined(__IPHONE_13_0)
        UISearchTextField *searchField = obj.searchTextField;
        searchField.keyboardAppearance = UIKeyboardAppearanceDark;
#elif defined(__IPHONE_7_0)
        UITextField *searchField = [obj valueForKey:@"_searchField"];
        searchField.keyboardAppearance = UIKeyboardAppearanceDark;
#else
        obj.keyboardAppearance = UIKeyboardAppearanceAlert;
#endif
    } else {
        // 键盘为普通模式
#if defined(__IPHONE_13_0)
        UISearchTextField *searchField = obj.searchTextField;
        searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
#elif defined(__IPHONE_7_0)
        UITextField *searchField = [obj valueForKey:@"_searchField"];
        searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
#else
        obj.keyboardAppearance = UIKeyboardAppearanceDefault;
#endif
    }

    return obj;
}

- (void)night_updateColor {
    // 先调用父类NSObject+Night分类中的方法
    [super night_updateColor];
    if (self.dk_manager.supportsKeyboard && [self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
#if defined(__IPHONE_13_0)
        UISearchTextField *searchField = self.searchTextField;
        searchField.keyboardAppearance = UIKeyboardAppearanceDark;
#elif defined(__IPHONE_7_0)
        UITextField *searchField = [self valueForKey:@"_searchField"];
        searchField.keyboardAppearance = UIKeyboardAppearanceDark;
#else
        self.keyboardAppearance = UIKeyboardAppearanceAlert;
#endif
    } else {
#if defined(__IPHONE_13_0)
        UISearchTextField *searchField = self.searchTextField;
        searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
#elif defined(__IPHONE_7_0)
        UITextField *searchField = [self valueForKey:@"_searchField"];
        searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
#else
        self.keyboardAppearance = UIKeyboardAppearanceDefault;
#endif
    }
}

@end

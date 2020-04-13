//
//  DKNightVersionManager.m
//  DKNightVersionManager
//
//  Created by Draveness on 4/14/15.
//  Copyright (c) 2015 Draveness. All rights reserved.
//

#import "DKNightVersionManager.h"

// 默认两个主题，普通、暗黑
NSString * const DKThemeVersionNormal = @"NORMAL";
NSString * const DKThemeVersionNight = @"NIGHT";

NSString * const DKNightVersionThemeChangingNotification = @"DKNightVersionThemeChangingNotification";

CGFloat const DKNightVersionAnimationDuration = 0.3;

NSString * const DKNightVersionCurrentThemeVersionKey = @"com.dknightversion.manager.themeversion";

@interface DKNightVersionManager ()

@end

@implementation DKNightVersionManager

+ (DKNightVersionManager *)sharedManager {
    static dispatch_once_t once;
    static DKNightVersionManager *instance;
    dispatch_once(&once, ^{
        instance = [self new];
        // 随主题修改导航栏默认为YES
        instance.changeStatusBar = YES;
        // 设置app启动后默认主题
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        DKThemeVersion *themeVersion = [userDefaults valueForKey:DKNightVersionCurrentThemeVersionKey];
        themeVersion = themeVersion ?: DKThemeVersionNormal;
        instance.themeVersion = themeVersion;
        // 键盘在暗黑主题下显示暗黑模式 默认为YES
        instance.supportsKeyboard = YES;
    });
    return instance;
}

// 创建单例对象
+ (DKNightVersionManager *)sharedNightVersionManager {
    return [self sharedManager];
}

// 设置暗黑主题，快捷方法
- (void)nightFalling {
    self.themeVersion = DKThemeVersionNight;
}

// 设置普通主题，快捷方法
- (void)dawnComing {
    self.themeVersion = DKThemeVersionNormal;
}

- (void)setThemeVersion:(DKThemeVersion *)themeVersion {
    if ([_themeVersion isEqualToString:themeVersion]) {
        // if type does not change, don't execute code below to enhance performance.
        return;
    }
    _themeVersion = themeVersion;

    // Save current theme version to user default 保存当前主题
    [[NSUserDefaults standardUserDefaults] setValue:themeVersion forKey:DKNightVersionCurrentThemeVersionKey];
    // 发送通知，使所有设置主题颜色的控件对象更新当前主题颜色
    [[NSNotificationCenter defaultCenter] postNotificationName:DKNightVersionThemeChangingNotification
                                                        object:nil];

    // 修改状态栏类型
    if (self.shouldChangeStatusBar) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([themeVersion isEqualToString:DKThemeVersionNight]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
#pragma clang diagnostic pop
    }
}

@end

//
//  SuccViewController.m
//  DKNightVersion
//
//  Created by Draveness on 4/28/15.
//  Copyright (c) 2015 Draveness. All rights reserved.
//

#import "SuccViewController.h"
#import <DKNightVersion/DKNightVersion.h>

@interface SuccViewController ()

@end

@implementation SuccViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置背景view/navigationbar/textfield主题颜色
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.navigationController.navigationBar.dk_tintColorPicker = DKColorPickerWithKey(TINT);

    UITextView *textField = [[UITextView alloc] init];
    textField.frame = CGRectMake(100, 100, 200, 200);
    textField.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    textField.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [self.view addSubview:textField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        // 切换普通主题快捷方式
        [self.dk_manager dawnComing];
    } else {
        // 切换暗黑主题快捷方式
        [self.dk_manager nightFalling];
    }
}

@end

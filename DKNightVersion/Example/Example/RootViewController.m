//
//  RootViewController.m
//  DKNightVerision
//
//  Created by Draveness on 4/14/15.
//  Copyright (c) 2015 Draveness. All rights reserved.
//

#import "RootViewController.h"
#import "SuccViewController.h"
#import "PresentingViewController.h"
#import <DKNightVersion/DKNightVersion.h>
#import "TableViewCell.h"

// 根据传入的类和属性名，为自定义的颜色属性生成了对应 picker 的存取方法
@pickerify(TableViewCell, cellTintColor)

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
    navigationLabel.text = @"DKNightVersion";
    navigationLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navigationLabel;

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Present" style:UIBarButtonItemStylePlain target:self action:@selector(present)];
    self.navigationItem.leftBarButtonItem = item;

    UIBarButtonItem *normalItem = [[UIBarButtonItem alloc] initWithTitle:@"Normal" style:UIBarButtonItemStylePlain target:self action:@selector(normal)];
    // 设置normalItem在各主题下的颜色
    // dk_tintColorPicker是UIBarButtonItem分类的属性，分类通过关联对象实现对属性值得存储
    // DKColorPickerWithKey()返回的是一个DKColorPicker类型的block
    normalItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    UIBarButtonItem *nightItem = [[UIBarButtonItem alloc] initWithTitle:@"Night" style:UIBarButtonItemStylePlain target:self action:@selector(night)];
    nightItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    UIBarButtonItem *redItem = [[UIBarButtonItem alloc] initWithTitle:@"Red" style:UIBarButtonItemStylePlain target:self action:@selector(red)];
    redItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);

    self.navigationItem.rightBarButtonItems = @[normalItem, nightItem, redItem];

//    self.tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
    // dk_backgroundColorPicker是UIView分类的属性
    // DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa)返回的是一个DKColorPicker类型的block
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    // dk_separatorColorPicker是UITableView分类的属性
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    // dk_textColorPicker是UILabel分类的属性
    navigationLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    // dk_barTintColorPicker是UINavigationBar分类的属性
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    // dk_tintColorPicker是UIBarButtonItem分类的属性
    self.navigationItem.leftBarButtonItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
}

- (void)night {
    // NSObject+Night分类中给每个对象添加dk_manager方法
    // 设置themeVersion后会发送DKNightVersionThemeChangingNotification通知，实现修改主题
    self.dk_manager.themeVersion = DKThemeVersionNight;
}

- (void)normal {
    self.dk_manager.themeVersion = DKThemeVersionNormal;
}

- (void)red {
    // 除NORMAL与NIGHT，还可以添加其他主题，在DKColorTable.txt中设置所有主题及相关信息
    self.dk_manager.themeVersion = @"RED";
}

- (void)change {

    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        // 切换普通主题快捷方式
        [self.dk_manager dawnComing];
    } else {
        // 切换暗黑主题快捷方式
        [self.dk_manager nightFalling];
    }
}

- (void)push {
    [self.navigationController pushViewController:[[SuccViewController alloc] init] animated:YES];
}

- (void)present {
    [self presentViewController:[[PresentingViewController alloc] init] animated:YES completion:nil];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self push];
}

@end

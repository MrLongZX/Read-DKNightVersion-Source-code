//
//  UIButton+Night.h
//  DKNightVersion
//
//  Created by Draveness on 15/12/9.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Night.h"

// 创建分类
@interface UIButton (Night)

// 添加不同状态下的不同主题颜色、图片方法
- (void)dk_setTitleColorPicker:(DKColorPicker)picker forState:(UIControlState)state;

- (void)dk_setBackgroundImage:(DKImagePicker)picker forState:(UIControlState)state;

- (void)dk_setImage:(DKImagePicker)picker forState:(UIControlState)state;

@end

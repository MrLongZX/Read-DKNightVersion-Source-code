//
//  UIView+Night.h
//  UIView+Night
//
//  Copyright (c) 2015 Draveness. All rights reserved.
//
//  These files are generated by ruby script, if you want to modify code
//  in this file, you are supposed to update the ruby code, run it and 
//  test it. And finally open a pull request.

#import <UIKit/UIKit.h>
#import "NSObject+Night.h"

// 看UIBarButtonItem+Night分类，同理
@interface UIView (Night)

@property (nonatomic, copy, setter = dk_setBackgroundColorPicker:) DKColorPicker dk_backgroundColorPicker;
@property (nonatomic, copy, setter = dk_setTintColorPicker:) DKColorPicker dk_tintColorPicker;

@end

//
//  CALayer+Night.h
//  DKNightVersion
//
//  Created by Draveness on 16/1/29.
//  Copyright © 2016年 DeltaX. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSObject+Night.h"

// 看UIBarButtonItem+Night分类，同理
@interface CALayer (Night)

@property (nonatomic, copy) DKColorPicker dk_shadowColorPicker;
@property (nonatomic, copy) DKColorPicker dk_borderColorPicker;
@property (nonatomic, copy) DKColorPicker dk_backgroundColorPicker;

@end

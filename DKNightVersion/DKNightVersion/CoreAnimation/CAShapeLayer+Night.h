//
//  CAShapeLayer+Night.h
//  tztMobileApp_HTSC
//
//  Created by YeTao on 2016/11/15.
//
//

#import <QuartzCore/QuartzCore.h>
#import "NSObject+Night.h"

// 看UIBarButtonItem+Night分类，同理
@interface CAShapeLayer (Night)

@property (nonatomic, copy) DKColorPicker dk_strokeColorPicker;
@property (nonatomic, copy) DKColorPicker dk_fillColorPicker;

@end

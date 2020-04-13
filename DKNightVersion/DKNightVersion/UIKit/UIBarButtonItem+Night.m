//
//  UIBarButtonItem+Night.m
//  UIBarButtonItem+Night
//
//  Copyright (c) 2015 Draveness. All rights reserved.
//
//  These files are generated by ruby script, if you want to modify code
//  in this file, you are supposed to update the ruby code, run it and
//  test it. And finally open a pull request.

#import "UIBarButtonItem+Night.h"
#import "DKNightVersionManager.h"
#import <objc/runtime.h>

@interface UIBarButtonItem ()

// 添加的私有属性，
@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation UIBarButtonItem (Night)

// 使用关联对象实现
- (DKColorPicker)dk_tintColorPicker {
    // 获取picker
    return objc_getAssociatedObject(self, @selector(dk_tintColorPicker));
}

- (void)dk_setTintColorPicker:(DKColorPicker)picker {
    // 保存picker
    objc_setAssociatedObject(self, @selector(dk_tintColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 调用picker这个block，传入当前主题，获取主题下对应颜色，对真正的属性赋颜色值
    self.tintColor = picker(self.dk_manager.themeVersion);
    // 获取NSObject+Night分类下为每个对象添加的pickers属性，将 picker 与 真正的赋颜色值方法 保存
    [self.pickers setValue:[picker copy] forKey:@"setTintColor:"];
}


@end

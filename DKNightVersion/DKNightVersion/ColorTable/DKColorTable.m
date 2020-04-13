//
//  DKColorTable.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/11.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "DKColorTable.h"

@interface NSString (Trimming)

@end

@implementation NSString (Trimming)

// 修整尾部的字符集
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

@end

@interface DKColorTable ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, UIColor *> *> *table;
@property (nonatomic, strong, readwrite) NSArray<DKThemeVersion *> *themes;

@end

@implementation DKColorTable

UIColor *DKColorFromRGB(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0];
}

UIColor *DKColorFromRGBA(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 24) & 0xFF)/255.0) green:((CGFloat)((hex >> 16) & 0xFF)/255.0) blue:((CGFloat)((hex >> 8) & 0xFF)/255.0) alpha:((CGFloat)(hex & 0xFF)/255.0)];
}

+ (instancetype)sharedColorTable {
    static DKColorTable *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[DKColorTable alloc] init];
        // 默认主题颜色配置表
        sharedInstance.file = @"DKColorTable.txt";
    });
    return sharedInstance;
}

// 重新加载颜色配置表
- (void)reloadColorTable {
    // Clear previos color table
    self.table = nil;
    self.themes = nil;

    // Load color table file
    NSString *filepath = [[NSBundle mainBundle] pathForResource:self.file.stringByDeletingPathExtension ofType:self.file.pathExtension];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];

    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);

    // 输入颜色配置表内容
    NSLog(@"DKColorTable:\n%@", fileContents);


    NSMutableArray *tempEntries = [[fileContents componentsSeparatedByString:@"\n"] mutableCopy];
    
    // Fixed whitespace error in txt file, fix https://github.com/Draveness/DKNightVersion/issues/64
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    [tempEntries enumerateObjectsUsingBlock:^(NSString *  _Nonnull entry, NSUInteger idx, BOOL * _Nonnull stop) {
        // 修整颜色配置表尾部的空格字符集
        NSString *trimmingEntry = [entry stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [entries addObject:trimmingEntry];
    }];
    // 使用谓词，进行过滤，去掉无用空字符串
    [entries filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];

    // 去掉主题内容一行
    [entries removeObjectAtIndex:0]; // Remove theme entry

    // 获取主题
    self.themes = [self themesFromContents:fileContents];
    
    // Add entry to color table
    for (NSString *entry in entries) {
        NSArray *colors = [self colorsFromEntry:entry];
        NSString *keys = [self keyFromEntry:entry];
        
        [self addEntryWithKey:keys colors:colors themes:self.themes];
    }
}

// 获取主题
- (NSArray *)themesFromContents:(NSString *)content {
    // 主题一行的字符串内容
    NSString *rawThemes = [content componentsSeparatedByString:@"\n"].firstObject;
    return [self separateString:rawThemes];
}

- (NSArray *)colorsFromEntry:(NSString *)entry {
    // 获取颜色配置表中某一行颜色配置的内容 如：
    //    <__NSArrayM>(
    //    #ffffff,
    //    #343434,
    //    #fafafa,
    //    BG
    //    )
    NSMutableArray *colors = [[self separateString:entry] mutableCopy];
    // 移除对颜色配置的名称，也就是最后一项
    [colors removeLastObject];
    NSMutableArray *result = [@[] mutableCopy];
    for (NSString *number in colors) {
        // 通过字符串创建颜色对象，添加到数组
        [result addObject:[self colorFromString:number]];
    }
    return result;
}

- (NSString *)keyFromEntry:(NSString *)entry {
    // 获取对颜色配置的名称
    return [self separateString:entry].lastObject;
}

- (void)addEntryWithKey:(NSString *)key colors:(NSArray *)colors themes:(NSArray *)themes {
    NSParameterAssert(themes.count == colors.count);

    __block NSMutableDictionary *themeToColorDictionary = [@{} mutableCopy];

    [themes enumerateObjectsUsingBlock:^(NSString * _Nonnull theme, NSUInteger idx, BOOL * _Nonnull stop) {
        [themeToColorDictionary setValue:colors[idx] forKey:theme];
    }];

    [self.table setValue:themeToColorDictionary forKey:key];
    // 最终获得self.table:
    //    {
    //        BG =     {
    //            NIGHT = "UIExtendedSRGBColorSpace 0.203922 0.203922 0.203922 1";
    //            NORMAL = "UIExtendedSRGBColorSpace 1 1 1 1";
    //            RED = "UIExtendedSRGBColorSpace 0.980392 0.980392 0.980392 1";
    //        };
    //        SEP =     {
    //            NIGHT = "UIExtendedSRGBColorSpace 0.192157 0.192157 0.192157 1";
    //            NORMAL = "UIExtendedSRGBColorSpace 0.666667 0.666667 0.666667 1";
    //            RED = "UIExtendedSRGBColorSpace 0.666667 0.666667 0.666667 1";
    //        };
    //        TINT =     {
    //            NIGHT = "UIExtendedSRGBColorSpace 1 1 1 1";
    //            NORMAL = "UIExtendedSRGBColorSpace 0 0 1 1";
    //            RED = "UIExtendedSRGBColorSpace 0.980392 0 0 1";
    //        };
    //    }
}

// 创建DKColorPicker
- (DKColorPicker)pickerWithKey:(NSString *)key {
    NSParameterAssert(key);

    // 根据key(在颜色配置表中对各主题颜色配置的名称)，主题颜色配置字典数据 如key为BG时：
    //    BG =     {
    //        NIGHT = "UIExtendedSRGBColorSpace 0.203922 0.203922 0.203922 1";
    //        NORMAL = "UIExtendedSRGBColorSpace 1 1 1 1";
    //        RED = "UIExtendedSRGBColorSpace 0.980392 0.980392 0.980392 1";
    //    };
    NSDictionary *themeToColorDictionary = [self.table valueForKey:key];
    DKColorPicker picker = ^(DKThemeVersion *themeVersion) {
        return [themeToColorDictionary valueForKey:themeVersion];
    };
    return picker;
}

#pragma mark - Getter/Setter

- (NSMutableDictionary *)table {
    if (!_table) {
        _table = [[NSMutableDictionary alloc] init];
    }
    return _table;
}

- (void)setFile:(NSString *)file {
    _file = file;
    [self reloadColorTable];
}

#pragma mark - Helper

// 通过配置的颜色字符串 创建color对象
- (UIColor*)colorFromString:(NSString*)hexStr {
    // 移除空格字符
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    if([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }

    NSUInteger hex = [self intFromHexString:hexStr];
    if(hexStr.length > 6) {
        return DKColorFromRGBA(hex);
    }

    return DKColorFromRGB(hex);
}

// 16进制字符串 转 10进制
- (NSUInteger)intFromHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;

    NSScanner *scanner = [NSScanner scannerWithString:hexStr];

    [scanner scanHexInt:&hexInt];

    return hexInt;
}

- (NSArray *)separateString:(NSString *)string {
    // 使用空格对字符串进行分割
    NSArray *array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 使用谓词过滤空字符串
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
}

@end

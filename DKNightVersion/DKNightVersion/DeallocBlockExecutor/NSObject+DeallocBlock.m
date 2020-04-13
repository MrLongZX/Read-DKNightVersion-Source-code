//
//  NSObject+DeallocBlock.m
//  DKNightVersion
//
//  Created by nathanwhy on 16/2/24.
//  Copyright © 2016年 Draveness. All rights reserved.
//

#import "NSObject+DeallocBlock.h"
#import "DKDeallocBlockExecutor.h"
#import <objc/runtime.h>

static void *kNSObject_DeallocBlocks;

@implementation NSObject (DeallocBlock)

- (id)addDeallocBlock:(void (^)())deallocBlock {
    if (deallocBlock == nil) {
        return nil;
    }
    
    // deallocBlocks数组用于保存下面的executor对象，
    NSMutableArray *deallocBlocks = objc_getAssociatedObject(self, &kNSObject_DeallocBlocks);
    if (deallocBlocks == nil) {
        deallocBlocks = [NSMutableArray array];
        objc_setAssociatedObject(self, &kNSObject_DeallocBlocks, deallocBlocks, OBJC_ASSOCIATION_RETAIN);
    }
    // Check if the block is already existed
    for (DKDeallocBlockExecutor *executor in deallocBlocks) {
        if (executor.deallocBlock == deallocBlock) {
            return nil;
        }
    }
    
    // 将deallocBlock传给DKDeallocBlockExecutor，保存并生成对象
    DKDeallocBlockExecutor *executor = [DKDeallocBlockExecutor executorWithDeallocBlock:deallocBlock];
    // 将executor保存到数组中，使其引用计数+1
    // 如果没有这个数组，返回executor后，在NSObject+Night分类中以OBJC_ASSOCIATION_ASSIGN保存，引用计数不加1，则executor会直接销毁
    [deallocBlocks addObject:executor];
    return executor;
}

@end

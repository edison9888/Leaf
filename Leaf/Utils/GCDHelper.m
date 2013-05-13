//
//  GCDHelper.m
//  Leaf
//
//  Created by roger on 13-5-13.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "GCDHelper.h"

@implementation GCDHelper

+ (void)dispatchBlock:(LeafGCDBlock)block complete:(LeafGCDBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            block();
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }
    });
}

@end

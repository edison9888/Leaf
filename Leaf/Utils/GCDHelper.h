//
//  GCDHelper.h
//  Leaf
//
//  Created by roger on 13-5-13.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LeafGCDBlock)(void);

@interface GCDHelper : NSObject
+ (void)dispatchBlock:(LeafGCDBlock)block complete:(LeafGCDBlock)completion;
@end

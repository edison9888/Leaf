//
//  LeafStatusBarOverlay.h
//  Leaf
//
//  Created by roger on 13-5-16.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafStatusBarOverlay : UIWindow

+ (LeafStatusBarOverlay *)sharedInstance;
- (void)postMessage:(NSString *)msg dismissAfterDelay:(int)delay;
@end

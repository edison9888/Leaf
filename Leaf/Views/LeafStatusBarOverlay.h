//
//  LeafStatusBarOverlay.h
//  Leaf
//
//  Created by roger on 13-5-16.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    LeafStatusBarOverlayTypeInfo,
    LeafStatusBarOverlayTypeSuccess,
    LeafStatusBarOverlayTypeWarning,
    LeafStatusBarOverlayTypeError
} LeafStatusBarOverlayType;

@interface LeafStatusBarOverlay : UIWindow

+ (LeafStatusBarOverlay *)sharedInstance;
- (void)postMessage:(NSString *)msg type:(LeafStatusBarOverlayType)type  dismissAfterDelay:(int)delay;
@end

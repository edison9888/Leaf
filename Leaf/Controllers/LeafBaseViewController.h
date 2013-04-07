//
//  LeafBaseViewController.h
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LeafBlock)(void);

typedef enum{
    LeafAnimationOptionHorizontal = 0,
    LeafAnimationOptionVertical
}LeafAnimationOption;

typedef enum{
    LeafPanDirectionNone,
    LeafPanDirectionLeft,
    LeafPanDirectionRight
} LeafPanDirection;

typedef enum{
    LeafPanCompletionNone,
    LeafPanCompletionLeft,
    LeafPanCompletionRight
} LeafPanCompletion;

typedef enum {
    LeafPanStateNone,
    LeafPanStateShowingLeft,
    LeafPanStateShowingRight
} LeafPanState;


@interface LeafBaseViewController : UIViewController
{
    UIView *_container;
    UIView *_mask;
    LeafPanDirection _panDirection;
    CGPoint _panVelocity;
    CGFloat _panOriginX;
    LeafPanState _state;
}

@property (nonatomic, assign) BOOL hasMask;

- (void)enablePanGesture;

- (void)presentViewController:(LeafBaseViewController *)controller option:(LeafAnimationOption)option completion:(LeafBlock)block;
- (void)dismissViewControllerWithOption:(LeafAnimationOption)option completion:(LeafBlock)block;

@end

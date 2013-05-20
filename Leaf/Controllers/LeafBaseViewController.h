//
//  LeafBaseViewController.h
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "DDMenuController.h"
#import "LeafStatusBarOverlay.h"

#define kSinaWeiboDidLogin @"SinaWeiboDidLogin"
#define kSinaWeiboDidLogout @"SinaWeiboDidLogout"


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
    LeafPanCompletionRoot,
    LeafPanCompletionLeft,
    LeafPanCompletionRight
} LeafPanCompletion;

typedef enum {
    LeafPanStateNone,
    LeafPanStateShowingLeft,
    LeafPanStateShowingRight
} LeafPanState;

@interface LeafBaseViewController : UIViewController <UIGestureRecognizerDelegate, SinaWeiboDelegate>
{
    UIView *_container;
    UIView *_mask;
    LeafPanDirection _panDirection;
    CGPoint _panVelocity;
    CGFloat _panOriginX;
    CGFloat _panEndX;
    LeafPanState _state;
    BOOL _shouldBlockGesture;
    LeafBaseViewController *_parentController;
    BOOL _canShowLeft;
    BOOL _canShowRight;
}


@property (nonatomic, copy) LeafBlock coveredBlock;
@property (nonatomic, copy) LeafBlock childDismissBlock;
@property (nonatomic, assign) BOOL hasMask;
@property (nonatomic, assign) BOOL shouldBlockGesture;
@property (nonatomic, assign) LeafBaseViewController *parentController;
@property (nonatomic, assign) LeafBaseViewController *childController;

- (void)pushController:(LeafBaseViewController *)controller;

- (void)enablePanLeftGestureWithWillCoverBlock:(LeafBlock)willCoverBlock coveredBlock:(LeafBlock)coveredBlock andDismissBlock:(LeafBlock)dismissBlock;
- (void)enablePanRightGestureWithDismissBlock:(LeafBlock)block;
- (void)blockDDMenuControllerGesture:(BOOL)block;

- (void)presentViewController:(LeafBaseViewController *)controller option:(LeafAnimationOption)option completion:(LeafBlock)block;
- (void)dismissViewControllerWithOption:(LeafAnimationOption)option completion:(LeafBlock)block;

- (SinaWeibo *)sinaweibo;

- (void)postMessage:(NSString *)msg;
- (void)postMessage:(NSString *)msg type:(LeafStatusBarOverlayType)type;
- (void)postMessage:(NSString *)msg type:(LeafStatusBarOverlayType)type dismissAfterDelay:(int)delay;

@end

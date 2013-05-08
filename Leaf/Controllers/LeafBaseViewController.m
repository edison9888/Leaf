//
//  LeafBaseViewController.m
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafBaseViewController.h"
#import "LeafHelper.h"
#import "LeafStack.h"


#define kScaleFactor 0.02f
#define kAlphaFactor 0.1f
#define kLeafEpisnon 0.5f
#define kLeafOffsetX 30.0f

@interface LeafBaseViewController ()

@property (nonatomic, copy) LeafBlock dismissBlock;
@property (nonatomic, copy) LeafBlock willCoverBlock;


@end

@implementation LeafBaseViewController

@synthesize parentController = _parentController;
@synthesize childController = _childController;

@synthesize hasMask = _hasMask;
@synthesize shouldBlockGesture = _shouldBlockGesture;
@synthesize dismissBlock = _dismissBlock;
@synthesize willCoverBlock = _willCoverBlock;
@synthesize coveredBlock = _coveredBlock;
@synthesize childDismissBlock = _childDismissBlock;


- (void)dealloc
{
    NSLog(@"LeafBaseViewController dealloc!");
    [_dismissBlock release], _dismissBlock = nil;
    [_willCoverBlock release], _willCoverBlock = nil;
    [_coveredBlock release], _coveredBlock = nil;
    [_childDismissBlock release], _childDismissBlock = nil;
    _parentController = nil;
    _childController = nil;
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        _shouldBlockGesture = NO;
        _canShowLeft = NO;
        _canShowRight = NO;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:container];
    _container = container;
    _container.backgroundColor = kLeafBackgroundColor;
    [container release];
    
    UIView *mask = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mask];
    mask.alpha = 0.1f;
    mask.hidden = YES;
    _mask = mask;
    _mask.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
    [mask release];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _parentController.shouldBlockGesture = NO;
}

- (void)blockDDMenuControllerGesture:(BOOL)block
{
    DDMenuController *menuController = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    menuController.shouldBlockGesture = block;
}

- (void)pushController:(LeafBaseViewController *)controller
{
    [[LeafStack sharedInstance] push:controller];
    controller.parentController = self;
    self.childController = controller;
    [self.view addSubview:controller.view];
    [controller.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [controller addObserver:self forKeyPath:@"hasMask" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark -
#pragma mark - KVO Stuff

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        UIView *contentView = (UIView *)object;
        CGFloat originX = contentView.frame.origin.x;
        CGFloat originY = contentView.frame.origin.y;
        
        CGFloat factor = 0;
        if (originX < kLeafEpisnon) {
            factor =  1 - originY/CGHeight(contentView.frame);
        }
        else if(originY < kLeafEpisnon){
            factor =  1 - originX/CGWidth(contentView.frame);
        }
       
        CGFloat scale = 1.0f - (kScaleFactor * factor);
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        _container.transform = transform;
        _mask.alpha = kAlphaFactor + factor;
    }
    else if([keyPath isEqualToString:@"hasMask"]){
        LeafBaseViewController *vc = (LeafBaseViewController *)object;
        _mask.hidden = !vc.hasMask;
    }
}

#pragma mark -
#pragma mark - Pan Gesture Stuff

- (void)enablePanRightGestureWithDismissBlock:(LeafBlock)block
{
    if (!_canShowRight) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
        [pan release];
    }
    _canShowLeft = YES;
    self.dismissBlock = block;
}

- (void)enablePanLeftGestureWithWillCoverBlock:(LeafBlock)willCoverBlock coveredBlock:(LeafBlock)coveredBlock andDismissBlock:(LeafBlock)dismissBlock
{
    if (!_canShowLeft) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
        [pan release];
    }

    _canShowRight = YES;
    self.willCoverBlock = willCoverBlock;
    self.coveredBlock = coveredBlock;
    self.childDismissBlock = dismissBlock;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return (!_shouldBlockGesture);
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        _panOriginX = self.view.frame.origin.x;
        _panVelocity = CGPointMake(0.0f, 0.0f);
        
        if([gesture velocityInView:self.view.superview].x > 0) {
            _panDirection = LeafPanDirectionRight;
        }
        else {
            _panDirection = LeafPanDirectionLeft;
            if (_canShowRight && _willCoverBlock) {
                _willCoverBlock();
            }
        }
        
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [gesture velocityInView:self.view.superview];
        if((velocity.x*_panVelocity.x + velocity.y*_panVelocity.y) < 0) {
            _panDirection = (_panDirection == LeafPanDirectionRight) ? LeafPanDirectionLeft : LeafPanDirectionRight;
        }
        
        _panVelocity = velocity;
        CGPoint translation = [gesture translationInView:self.view.superview];
        CGRect frame = self.view.frame;
        frame.origin.x = _panOriginX + translation.x;

        if(frame.origin.x > 0 && _canShowLeft)
        {
            if (_state == LeafPanStateNone && _panDirection == LeafPanDirectionRight) {
                _state = LeafPanStateShowingLeft;
            }
            if (_state == LeafPanStateShowingLeft) {
                self.view.frame = frame;
                _panEndX = frame.origin.x;
            }
        }
        else if(_canShowRight)
        {
            if (_state == LeafPanStateNone && _panDirection == LeafPanDirectionLeft) {
                _state = LeafPanStateShowingRight;
            }
            if (_state == LeafPanStateShowingRight) {
                if (_childController) {
                    CGRect childFrame = _childController.view.frame;
                    childFrame.origin.x = 320.0f + translation.x;
                    if (childFrame.origin.x < 0) {
                        childFrame.origin.x = 0.0f;
                    }
                    _childController.view.frame = childFrame;
                }
            }

        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        LeafPanCompletion  completion =  LeafPanCompletionNone;
        
        if(_canShowLeft && _state == LeafPanStateShowingLeft && (_panEndX < kLeafOffsetX || _panDirection == LeafPanDirectionLeft))
        {
            completion = LeafPanCompletionRoot;
        }
        else if (_canShowLeft && _state == LeafPanStateShowingLeft && _panDirection == LeafPanDirectionRight) {
            completion = LeafPanCompletionLeft;
        }
       
        else if(_canShowRight && _state == LeafPanStateShowingRight && _panDirection == LeafPanDirectionLeft)
        {
            completion = LeafPanCompletionRight;
        }
        else if(_canShowRight && _state == LeafPanStateShowingRight && _panDirection == LeafPanDirectionRight)
        {
            completion = LeafPanCompletionNone;
        }
    
        
        if (completion == LeafPanCompletionLeft) {
            [self viewWillDisappear:YES];
            __block CGRect frame = self.view.frame;
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 frame.origin.x = CGWidth(self.view.frame);
                                 self.view.frame = frame;
                             }
                             completion:^(BOOL finished) {
                                 if (_dismissBlock) {
                                     _dismissBlock();
                                 }
                                 self.hasMask = NO;
                                 self.parentController.childController = nil;
                                 [self removeObserver:self.parentController forKeyPath:@"hasMask"];
                                 [self.view removeObserver:self.parentController forKeyPath:@"frame"];
                                 [self.view removeFromSuperview];
                                 [self viewDidDisappear:YES];
                                 [[LeafStack sharedInstance] pop:self];
                                 
                             }];

        }
        else if(completion == LeafPanCompletionRoot){
            if (self.view.frame.origin.x > 0) {
                __block CGRect frame = self.view.frame;
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     frame.origin.x = 0.0f;
                                     self.view.frame = frame;
                                 }
                                 completion:^(BOOL finished) {
                                     _state = LeafPanStateNone;
                                 }];
            }
        }

        else if(completion == LeafPanCompletionRight){
            if (_childController) {
                __block CGRect frame = _childController.view.frame;
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     frame.origin.x = 0.0f;
                                     _childController.view.frame = frame;
                                 }
                                 completion:^(BOOL finished) {
                                     if (_coveredBlock) {
                                         _coveredBlock();
                                     }
                                     _state = LeafPanStateNone;
                                 }];

            }
        }
        else if(_canShowRight && completion == LeafPanCompletionNone){
            if (_childController) {
                __block CGRect frame = _childController.view.frame;
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     frame.origin.x = CGWidth(self.view.frame);
                                     _childController.view.frame = frame;
                                 }
                                 completion:^(BOOL finished) {
                                     if (_childDismissBlock) {
                                         _childDismissBlock();
                                     }
                                     _childController.hasMask = NO;
                                     [_childController removeObserver:self forKeyPath:@"hasMask"];
                                     [_childController.view removeObserver:self forKeyPath:@"frame"];
                                     [_childController.view removeFromSuperview];
                                     [_childController viewDidDisappear:YES];
                                     [[LeafStack sharedInstance] pop:_childController];
                                     _childController = nil;
                                     _state = LeafPanStateNone;
                                 }];
                
            }
        }

        
    }
}



#pragma mark -
#pragma mark - ViewController Presentation

- (void)presentViewController:(LeafBaseViewController *)controller option:(LeafAnimationOption)option completion:(LeafBlock)block
{
    if (!controller) {
        NSLog(@"controller is nil.");
        return;
    }
    [[LeafStack sharedInstance] push:controller];
    self.childController = controller;
    controller.parentController = self;
    [controller.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [controller addObserver:self forKeyPath:@"hasMask" options:NSKeyValueObservingOptionNew context:NULL];
    [controller viewWillAppear:YES];
    
    if (option == LeafAnimationOptionHorizontal) {
        CGRect rect = controller.view.frame;
        rect.origin.x = CGWidth(self.view.bounds);
        controller.view.frame = rect;
        [self.view addSubview:controller.view];
        controller.hasMask = YES;
        
        __block CGRect frame = controller.view.frame;
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             frame.origin.x = 0.0f;
                             controller.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             if (block) {
                                 block();
                             }
                             [controller viewDidAppear:YES];
                         }];
    }
    else if (option == LeafAnimationOptionVertical) {
        CGRect rect = controller.view.frame;
        rect.origin.y = CGHeight(self.view.bounds);
        controller.view.frame = rect;
        [self.view addSubview:controller.view];
        controller.hasMask = YES;
        
        __block CGRect frame = controller.view.frame;
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             frame.origin.y = 0.0f;
                             controller.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             if (block) {
                                 block();
                             }
                             [controller viewDidAppear:YES];
                         }];
    }

}

- (void)dismissViewControllerWithOption:(LeafAnimationOption)option completion:(LeafBlock)block
{
    __block CGRect frame = self.view.frame;
    [self viewWillDisappear:YES];
    if (option == LeafAnimationOptionHorizontal) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             frame.origin.x = CGWidth(self.view.frame);
                             self.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             if (block) {
                                block(); 
                             }
                             self.hasMask = NO;
                             self.parentController.childController = nil;
                             [self removeObserver:self.parentController forKeyPath:@"hasMask"];
                             [self.view removeObserver:self.parentController forKeyPath:@"frame"];
                             [self.view removeFromSuperview];
                             [self viewDidDisappear:YES];
                             [[LeafStack sharedInstance] pop:self];
                         }];
    }
    else if (option == LeafAnimationOptionVertical) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             frame.origin.y = CGHeight(self.view.frame);
                             self.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             if (block) {
                                 block();
                             }
                             self.hasMask = NO;
                             self.parentController.childController = nil;
                             [self removeObserver:self.parentController forKeyPath:@"hasMask"];
                             [self.view removeObserver:self.parentController forKeyPath:@"frame"];
                             [self.view removeFromSuperview];
                             [self viewDidDisappear:YES];
                             [[LeafStack sharedInstance] pop:self];
                         }];
    }
}


#pragma mark -
#pragma mark - SinaWeibo Stuff

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.weibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark - SinaWeiboDelegate Methods

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthData];
}




@end

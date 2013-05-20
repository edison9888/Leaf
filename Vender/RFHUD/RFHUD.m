//
//  RFHUD.m
//  
//
//  Created by roger on 13-4-16.
//  Copyright (c) 2013年 Mobim. All rights reserved.
//

#import "RFHUD.h"

#define kRFHUDDismissAfterDelay 1.0f
#define kRFHUDYScale 0.325
@interface RFHUD ()
{
    @private
    UIView *_hud;
    UIImageView *_hudBackground;
    UIImageView *_logo;
    UILabel *_status;
    UIButton *_cancel;
    UIView *_mask;
    RFHUDType _type;
    BOOL _complete;
    UIActivityIndicatorView *_activity;
}

@end


@implementation RFHUD
@synthesize hudFont = _hudFont;
@synthesize dismissBlock = _dismissBlock;

static RFHUD *_instance;

+ (id)sharedInstance
{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (!_instance) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return nil;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (id)init
{
    CGRect frame = [[UIApplication sharedApplication] keyWindow].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"HUD frame: %@", NSStringFromCGRect(frame));
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        UIView *mask = [[UIView alloc] initWithFrame:self.bounds];
        mask.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        _mask = mask;
        [self addSubview:mask];
        [mask release];
        
        UIView *hud = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame), kRFHUDYScale * CGRectGetHeight(self.frame), 180.0f, 94.0f)];
        _hud = hud;
        [self addSubview:hud];
        [hud release];
        
        UIImageView *backgroud= [[UIImageView alloc] initWithFrame:CGRectMake(33.0f, 0.0f, 145.0f, 94.0f)];
        [backgroud setImage:[UIImage imageNamed:@"RFHUD.bundle/activity_hud_bg"]];
        [backgroud setUserInteractionEnabled:YES];
        _hudBackground = backgroud;
        [_hud addSubview:backgroud];
        [backgroud release];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setImage:[UIImage imageNamed:@"RFHUD.bundle/activity_close"] forState:UIControlStateNormal];
        cancel.frame = CGRectMake(0.0f, 2.0f, 35.0f, 36.0f);
        [cancel addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        cancel.hidden = YES;
        _cancel = cancel;
        [_hud addSubview:cancel];
        
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_hudBackground.frame) - 34.0f)/2.0f, 12.0f, 34.0f, 34.0f)];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        _logo = logo;
        [_hudBackground addSubview:_logo];
        [logo release];
        
        UIFont *hudFont = [UIFont systemFontOfSize:16.0f];
        self.hudFont = hudFont;
        
        UILabel *status = [[UILabel alloc] initWithFrame:CGRectZero];
        status.font = _hudFont;
        status.textColor = [UIColor whiteColor];
        status.backgroundColor = [UIColor clearColor];
        _status = status;
        [_hudBackground addSubview:_status];
        [status release];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activity.frame = _logo.frame;
        activity.hidden = YES;
        _activity = activity;
        [_hudBackground addSubview:_activity];
        [activity release];
        
    }
    return self;
}

- (void)close
{
    _complete = YES;
}


- (void)close:(id)sender
{
    _complete = YES;
}

- (void)setHUDType:(RFHUDType)type andStatus:(NSString *)status
{
    _type = type;
    _cancel.hidden = YES;
    _logo.transform = CGAffineTransformIdentity;
    _logo.hidden = NO;
    
    switch (type) {
           case RFHUDTypeLoading:
            [_logo setImage:[UIImage imageNamed:@"RFHUD.bundle/activity_logo_circle"]];
            _cancel.hidden = NO;
            break;
        case RFHUDTypeSuccess:
            [_logo setImage:[UIImage imageNamed:@"RFHUD.bundle/activity_logo_success"]];
            break;
        case RFHUDTypeError:
            [_logo setImage:[UIImage imageNamed:@"RFHUD.bundle/activity_logo_error"]];
            break;
        case RFHUDTypeWaiting:
            _logo.hidden = YES;
            _activity.hidden = NO;
            [_activity startAnimating];
            break;

        default:
            break;
    }
    
    
    CGSize statusSize = [status sizeWithFont:_hudFont constrainedToSize:CGSizeMake(CGRectGetWidth(_hudBackground.frame), 16.0f)];
    _status.font = _hudFont;
    _status.frame = CGRectMake((CGRectGetWidth(_hudBackground.frame) - statusSize.width)/2.0f, CGRectGetMaxY(_logo.frame) + 10.0f, statusSize.width, statusSize.height);
    [_status setText:status];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay
{

    _complete = YES;
    __block CGRect frame = _hud.frame;
    
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         frame.origin.x = CGRectGetWidth(self.frame);
                         _hud.frame = frame;
                         _mask.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (!_activity.hidden) {
                             [_activity stopAnimating];
                         }
                         self.hidden = YES;
                         
                         if (_dismissBlock) {
                             _dismissBlock();
                         }
                     }];
    
    
}

- (void)dismiss
{
    if (_type == RFHUDTypeLoading) {
        [self close];
    }
    else{
        [self dismissAfterDelay:0.0f];
    }
}

- (void)rotateLogo
{
    UIImageView *logo = _logo;
    [UIView animateWithDuration:0.28f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGAffineTransform transform =  CGAffineTransformRotate(logo.transform, M_PI/2.0f);
                         logo.transform = transform;
                    }
                    completion:^(BOOL finished) {
                        if (!_complete) {
                            [self rotateLogo];
                        }
                        else{
                            [self dismissAfterDelay:0.0f];
                        }
                        
                    }];
}


- (void)show:(BOOL)front
{
    self.hidden = NO;
    if (!front) {
        self.windowLevel = UIWindowLevelAlert - 1.0f;
    }
    else
    {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
    }
        
    __block CGRect frame = _hud.frame;
    RFHUD *rf = self;
        
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         frame.origin.x = 147.0f;
                         _hud.frame = frame;
                         _mask.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         if (_type == RFHUDTypeLoading) {
                             _complete = NO;
                             [rf rotateLogo];
                         }
                         else if(_type != RFHUDTypeWaiting){
                             [rf dismissAfterDelay:kRFHUDDismissAfterDelay];
                         }
                    }];
    

}

- (void)show
{
    [self show:NO];
}

- (void)showInFront
{
    [self show:YES];
}


@end

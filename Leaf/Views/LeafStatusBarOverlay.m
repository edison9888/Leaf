//
//  LeafStatusBarOverlay.m
//  Leaf
//
//  Created by roger on 13-5-16.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafStatusBarOverlay.h"
#import "UIColor+MLPFlatColors.h"
#import "Singleton.h"

#define kLeafStatusBarOverlayBeforeAnimationFrame CGRectMake(0.0f, -20.0f, 320.0f, 20.0f)
#define kLeafStatusBarOverlayAfterAnimationFrame CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)
#define kLeafStatusBarLabelFrame CGRectMake(20.0f, 0.0f, 300.0f, 20.0f)
#define kLeafStatusEaseOutAnimationDuration 0.4f
#define kLeafStatusEaseInAnimationDuration 0.3f

@interface LeafStatusBarOverlay ()
{
    UILabel *_label;
}
@end

@implementation LeafStatusBarOverlay

SINGLETON_FOR_CLASS(LeafStatusBarOverlay);

- (id)init
{
    CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        self.backgroundColor = [UIColor flatBlueColor];
        self.frame = frame;
        UILabel *label = [[UILabel alloc] initWithFrame:kLeafStatusBarLabelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.font = kLeafFont15;
        label.textColor = [UIColor flatWhiteColor];
        _label = label;
        [self addSubview:label];
        [label release];
    }
    return self;
}

- (void)pickColorForType:(LeafStatusBarOverlayType)type
{
    _label.textColor = [UIColor flatWhiteColor];
    
    if (type == LeafStatusBarOverlayTypeSuccess) {
        self.backgroundColor = [UIColor flatGreenColor];
    }
    
    else if(type == LeafStatusBarOverlayTypeError){
        self.backgroundColor = [UIColor flatRedColor];
    }
    else if(type == LeafStatusBarOverlayTypeWarning)
    {
        self.backgroundColor = [UIColor flatYellowColor];
        _label.textColor = [UIColor flatBlackColor];
    }
    else {
        self.backgroundColor = [UIColor flatBlueColor];
    }
}

- (void)postMessage:(NSString *)msg type:(LeafStatusBarOverlayType)type dismissAfterDelay:(int)delay
{
    if (!self.hidden) {
        NSLog(@"posting msg, try latter.");
        return;
    }
    
    [self pickColorForType:type];
    
    self.frame = kLeafStatusBarOverlayBeforeAnimationFrame;
    self.hidden = NO;
    _label.text = msg;
    
    [UIView animateWithDuration:kLeafStatusEaseOutAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = kLeafStatusBarOverlayAfterAnimationFrame;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:kLeafStatusEaseInAnimationDuration
                                               delay:delay
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.frame = kLeafStatusBarOverlayBeforeAnimationFrame;
                                          }
                                          completion:^(BOOL finished) {
                                              self.hidden = YES;
                                          }];
                     }];
}

@end

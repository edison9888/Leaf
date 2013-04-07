//
//  LeafPhotoProgressBar
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafPhotoProgressBar.h"
#import "LeafHelper.h"

#define kLeafBlueProgressColor [UIColor colorWithRed:CGColorConvert(39.0f) green:CGColorConvert(149.0f) blue:CGColorConvert(228.0f) alpha:1.0f]

@interface LeafPhotoProgressBar ()
{
    UIView *_progress;
}
@end

@implementation LeafPhotoProgressBar

- (void)dealloc
{
    _progress = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIView *progress = [[UIView alloc] initWithFrame:self.bounds];
        progress.backgroundColor = kLeafBlueProgressColor;
        [self addSubview:progress];
        _progress = progress;
        [progress release];
    }
    return self;
}

- (void)setProgress:(float)progress
{
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    
    CGFloat width = CGWidth(self.bounds);
    CGRect frame = _progress.frame;
    frame.size.width = width * progress;
    NSLog(@"new frame: %@", NSStringFromCGRect(frame));
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _progress.frame = frame;
                     }
                     completion:NULL];
}

@end

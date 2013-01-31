//
//  LeafLoadingView.m
//  Leaf
//
//  Created by roger on 13-1-31.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafLoadingView.h"
#import "LeafHelper.h"

@implementation LeafLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kLeafHighlightColor;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setFrame:CGRectMake(20.0f, 5.0f, 20.0f, 20.0f)];
        [self addSubview:indicator];
        _indicator = indicator;
        [_indicator startAnimating];
        [indicator release];
        
        UILabel *label = [[UILabel alloc] initWithText:@"正在加载..." font:kLeafBoldFont13 textColor:[UIColor blackColor] andOrigin:CGPointZero];
        label.center = CGPointMake(CGWidth(frame)/2.0f, CGHeight(frame)/2.0f);
        [self addSubview:label];
    }
    return self;
}

- (void)startAnimation
{
    [_indicator startAnimating];
}

@end

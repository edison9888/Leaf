//
//  LeafMenuItem.m
//  Leaf
//
//  Created by roger qian on 13-3-29.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMenuItem.h"
#import "LeafHelper.h"

#define kLeafMenuMarginX 15.0f

@implementation LeafMenuItem
@synthesize color = _color;

- (void)dealloc
{
    [_color release], _color = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 16.0f)];
        [self addSubview:logo];
        _logo = logo;
        [logo release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _title = label;
        [_title setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
        [label release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    _title.textColor = _color;
}

- (void)setImage:(UIImage *)image
{
    _logo.image = image;
    CGPoint center = _logo.center;
    center.y = CGHeight(self.frame)/2.0f;
    _logo.center = center;
}

- (void)setTitle:(NSString *)text highlight:(UIColor *)color
{
    self.color = color;
    [_title setFont:kLeafBoldFont16];
    CGSize size = [text sizeWithFont:kLeafBoldFont16 constrainedToSize:CGSizeMake(240, 40)];
    _title.textColor = [UIColor whiteColor];
    _title.text = text;
    CGFloat originX = CGOriginX(_logo.frame) + CGWidth(_logo.frame) + kLeafMenuMarginX;
    [_title setFrame:CGRectMake(originX, 0.0f, size.width, size.height)];
    CGPoint center = _title.center;
    center.y = CGHeight(self.frame)/2.0f;
    _title.center = center;
}

@end

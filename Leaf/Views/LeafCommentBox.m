//
//  LeafCommentBox.m
//  Leaf
//
//  Created by roger qian on 13-1-28.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCommentBox.h"
#import "LeafHelper.h"

#define kGreenColor [UIColor colorWithRed:CGColorConvert(74.0f) green:CGColorConvert(135.0f) blue:CGColorConvert(18.0f) alpha:1.0f]
#define kBlueColor [UIColor colorWithRed:CGColorConvert(0.0f) green:CGColorConvert(87.0f) blue:CGColorConvert(84.0f) alpha:1.0f]
#define kPureBlueColor [UIColor colorWithRed:CGColorConvert(0.0f) green:CGColorConvert(51.0f) blue:CGColorConvert(84.0f) alpha:1.0f]
#define kLightGreenColor [UIColor colorWithRed:CGColorConvert(148.0f) green:CGColorConvert(173.0f) blue:CGColorConvert(31.0f) alpha:1.0f]
#define kYellowColor [UIColor colorWithRed:CGColorConvert(255.0f) green:CGColorConvert(214.0f) blue:CGColorConvert(0.0f) alpha:1.0f]


@implementation LeafCommentBox

- (void)dealloc
{
    
    _colorful = nil;
    _count = nil;
    [super dealloc];
}

- (id)init
{
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_box"]];
    self = [super initWithFrame:background.frame];
    if (self) {         
        [self addSubview:background];               
        UIImageView *color = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 24.0f, 16.0f)];
        [self addSubview:color];
        _colorful = color;
        [color release];
        
        _center = CGPointMake(CGWidth(_colorful.frame)/2.0f, CGHeight(_colorful.frame)/2.0f);
        
        UILabel *count = [[UILabel alloc] init];
        _count = count;
        _count.backgroundColor = [UIColor clearColor];
        _count.font = kLeafFont10;
        [_colorful addSubview:_count];
        [count release];
    }
    [background release]; 
    return self;
}

- (void)setText:(NSString *)count
{
    int value = [count intValue];
    NSString *text = count;
    if (value > 1000) {
        text = @"999";
    }
    UIImage *image = nil;
    [_count setTextColor:[UIColor whiteColor]];
    switch (arc4random() % 5) {
        case LeafColorTypeGreen:
            image = [UIImage imageWithColor:kGreenColor];
            break;
        case LeafColorTypeBlue:
            image = [UIImage imageWithColor:kBlueColor];
            break;
        case LeafColorTypePureBlue:
            image = [UIImage imageWithColor:kPureBlueColor];
            break;
        case LeafColorTypeLightGreen:
            image = [UIImage imageWithColor:kLightGreenColor];
            break;
        case LeafColorTypeYellow:
            image = [UIImage imageWithColor:kYellowColor];
            [_count setTextColor:[UIColor blackColor]];
            break;            
        default:
            image = [UIImage imageWithColor:kPureBlueColor];
            break;
    }
    
    [_colorful setImage:image];
    CGSize size = [text sizeWithFont:kLeafFont10 constrainedToSize:_colorful.frame.size];
    [_count setFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    [_count setText:text];
    _count.center = _center;
}

@end

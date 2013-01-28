//
//  LeafNavigationBar.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafNavigationBar.h"
#import "LeafHelper.h"

@implementation LeafNavigationBar


- (id)init
{
    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
    CGRect frame = header.frame;
    self = [super initWithFrame:frame];
    if (self) {
        [header setUserInteractionEnabled:YES];
        [self addSubview:header];
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_shadow"]];
        [shadow setFrame:CGRectMake(CGOriginX(header.frame), CGHeight(header.frame) - 2.0f, CGWidth(shadow.frame), CGHeight(shadow.frame))];
        [self addSubview:shadow];
        [shadow release];
    }
    
    [header release];
    return self;
}

- (void)addHomeItemWithTarget:(id)target action:(SEL)action
{
    UIImage *menuImage =  [UIImage imageNamed:@"menu"];
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:CGColorConvert(135.0f) green:CGColorConvert(192.0f) blue:CGColorConvert(50.0f) alpha:1.0f]] forState:UIControlStateHighlighted];
    [menuBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setFrame:CGRectMake(16.0f, 8.0f, CGWidth(menuImage), CGHeight(menuImage))];
    [self addSubview:menuBtn];
}

- (void)addItemWithStyle:(LeafNavigationItemStyle)style target:(id)target action:(SEL)action
{
    switch (style) {
        case LeafNavigationItemStyleHome:
            [self addHomeItemWithTarget:target action:action];
            break;
            
        default:
            break;
    }
}

@end

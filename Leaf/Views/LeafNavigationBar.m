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
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    if (self) {        
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_shadow"]];
        [shadow setFrame:CGRectMake(0.0f, 42.0f, CGWidth(shadow.frame), CGHeight(shadow.frame))];
        [self addSubview:shadow];
        [shadow release];
        
        
    }
    
    [self setBackgroundColor:[UIColor colorWithRed:CGColorConvert(236.0f) green:CGColorConvert(234.0f) blue:CGColorConvert(226.0f) alpha:1.0f]];    
    return self;
}

- (void)addHomeItemWithTarget:(id)target action:(SEL)action
{
    UIImage *menuImage =  [UIImage imageNamed:@"menu"];
    [_leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_leftIcon setImage:menuImage];
}

- (void)addBackItemWithTarget:(id)target action:(SEL)action
{
    UIImage *backImage = [UIImage imageNamed:@"back"];
    [_leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_leftIcon setImage:backImage];
}

- (void)addLeftItemWithStyle:(LeafNavigationItemStyle)style target:(id)target action:(SEL)action
{
    if (_leftBtn) {
        NSLog(@"leftBtn already exists.");
        return;
    }
    UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(16.0f, 8.0f, 30.0f, 30.0f)];
    _leftIcon = leftIcon;        
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addSubview:_leftIcon];
    [leftIcon release];
    _leftBtn = leftBtn;
    [_leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:CGColorConvert(217.0f) green:CGColorConvert(217.0f) blue:CGColorConvert(216.0f) alpha:1.0f]] forState:UIControlStateHighlighted];
    //[UIImage imageWithColor:[UIColor colorWithRed:CGColorConvert(4.0f) green:CGColorConvert(135.0f) blue:CGColorConvert(220.0f) alpha:1.0f]] forState:UIControlStateHighlighted];
    [leftBtn setFrame:CGRectMake(0.0f, 0.0f, CGWidth(_leftIcon.frame) + 22.0f, 44.0f)];
    [self addSubview:_leftBtn];
    switch (style) {
        case LeafNavigationItemStyleMenu:
            [self addHomeItemWithTarget:target action:action];
            break;
        case LeafNavigationItemStyleBack:
            [self addBackItemWithTarget:target action:action];
            break;
        default:
            break;
    }
}

- (void)addRightItemWithStyle:(LeafNavigationItemStyle)style target:(id)target action:(SEL)action
{
    if (_rightBtn) {
        NSLog(@"rightBtn already exists.");
        return;
    }
    
    UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(16.0f, 8.0f, 30.0f, 30.0f)];
    _rightIcon = rightIcon;        
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addSubview:_rightIcon];
    [rightIcon release];
    _rightBtn = rightBtn;
    [_rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:CGColorConvert(217.0f) green:CGColorConvert(217.0f) blue:CGColorConvert(216.0f) alpha:1.0f]] forState:UIControlStateHighlighted];
    //[UIImage imageWithColor:[UIColor colorWithRed:CGColorConvert(4.0f) green:CGColorConvert(135.0f) blue:CGColorConvert(220.0f) alpha:1.0f]] forState:UIControlStateHighlighted];
    CGFloat width = CGWidth(_rightIcon.frame) + 22.0f;
    [rightBtn setFrame:CGRectMake(CGWidth(self.frame) - width, 0.0f, width, 44.0f)];
    [self addSubview:_rightBtn];
    
    switch (style) {
        case LeafNavigationItemStyleSafari:
            [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [_rightIcon setImage:[UIImage imageNamed:@"safari"]];
            break;
            
        default:
            break;
    }
 
}



- (void)setTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithText:title font:kLeafFont13 textColor:[UIColor blackColor] andOrigin:CGPointMake(0.0f, 0.0f) constrainedToSize:CGSizeMake(220.0f, 40.0f)];
    label.center = CGPointMake(CGWidth(self.frame)/2.0f, CGHeight(self.frame)/2.0f);
    [self addSubview:label];
    [label release];
}

@end

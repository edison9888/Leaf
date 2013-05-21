//
//  LeafNavigationBar.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import "UIColor+MLPFlatColors.h"

#import "LeafNavigationBar.h"
#import "LeafHelper.h"
#import "LeafCommentBox.h"

@implementation LeafNavigationBar

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    if (self) {        
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_shadow"]];
        [shadow setFrame:CGRectMake(0.0f, 40.0f, CGWidth(shadow.frame), CGHeight(shadow.frame))];
        [self addSubview:shadow];
        [shadow release];       
    }
    
    [self setBackgroundColor:[UIColor flatWhiteColor]];
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
    [_leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor flatDarkWhiteColor]]forState:UIControlStateHighlighted];
   
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


- (void) addRightItemWithStyle:(LeafNavigationItemStyle)style target:(id)target action:(SEL)action
{
    [self addRightItemWithStyle:style middle:NO target:target action:action];
}


- (void)addCommentBox:(NSString *)count target:(id)target action:(SEL)action
{
    LeafCommentBox *box = [[LeafCommentBox alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn  setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:CGColorConvert(217.0f) green:CGColorConvert(217.0f) blue:CGColorConvert(216.0f) alpha:1.0f]] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn addSubview:box];
    CGSize btnSize = CGSizeMake(44.0f, 44.0f);
    box.center = CGPointMake(btnSize.width/2.0f, btnSize.height/2.0f + 2.0f);
    [box setText:count];
    [box release];
    [btn setFrame:CGRectMake(CGWidth(self.frame) - btnSize.width, 0.0f, btnSize.width, btnSize.height)];
    [self addSubview:btn];
}

- (void)addRightItemWithStyle:(LeafNavigationItemStyle)style middle:(BOOL)middle target:(id)target action:(SEL)action
{
    if (_rightBtn) {
        NSLog(@"rightBtn already exists.");
        return;
    }
    
    UIImageView *rightIcon = [[UIImageView alloc] init];
    _rightIcon = rightIcon;        
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addSubview:_rightIcon];
    [rightIcon release];
    _rightBtn = rightBtn;
    [_rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor flatDarkWhiteColor]] forState:UIControlStateHighlighted];
    
    CGFloat originX = 0.0f;
    CGFloat width = 0.0f;
    if (middle) {
        [_rightIcon setFrame:CGRectMake(11.0f, 6.0f, 30.0f, 30.0f)];
        width = CGWidth(_rightIcon.frame) + 12.0f;
        originX = CGWidth(self.frame) - width - 44.0f;
    }
    else
    {
        [_rightIcon setFrame:CGRectMake(6.0f, 8.0f, 30.0f, 30.0f)];
        width = CGWidth(_rightIcon.frame) + 22.0f;
        originX = CGWidth(self.frame) - width;
    }
    
    [rightBtn setFrame:CGRectMake(originX , 0.0f, width, 44.0f)];
    [self addSubview:_rightBtn];
    
    switch (style) {
        case LeafNavigationItemStyleSafari:
            [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [_rightIcon setImage:[UIImage imageNamed:@"safari"]];
            break;
        case LeafNavigationItemStyleShare:
            [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [_rightIcon setImage:[UIImage imageNamed:@"share"]];
            break;
        case LeafNavigationItemStyleRefresh:
            [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [_rightIcon setImage:[UIImage imageNamed:@"refresh"]];
            break;
        default:
            break;
    }
 
}

- (void)setTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithText:title font:kLeafFont19 textColor:[UIColor flatBlackColor] andOrigin:CGPointMake(0.0f, 0.0f) constrainedToSize:CGSizeMake(220.0f, 40.0f)];
    label.center = CGPointMake(CGWidth(self.frame)/2.0f, CGHeight(self.frame)/2.0f);
    [self addSubview:label];
    [label release];
}

@end

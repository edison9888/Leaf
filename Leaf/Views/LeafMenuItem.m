//
//  LeafMenuItem.m
//  Leaf
//
//  Created by roger qian on 13-3-29.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMenuItem.h"
#import "LeafHelper.h"

#define kLeafMenuMarginX 16.0f
#define kLeafMenuLeftBtnWidth 58.0f
#define kLeafMenuLeftBtnHeight 58.0f
#define kLeafMenuPaddingLeft 1.0f
@implementation LeafMenuItem

- (void)dealloc
{
    [super dealloc];
}


- (void)setImage:(UIImage *)image
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn = leftBtn;
    _leftBtn.frame = CGRectMake(0.0f, 0.0f, kLeafMenuLeftBtnWidth, kLeafMenuLeftBtnHeight);
        
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    [_leftBtn addSubview:logo];
    logo.image = image;
    CGPoint center = CGPointMake(CGWidth(leftBtn.frame)/2.0f, CGHeight(leftBtn.frame)/2.0f);
    logo.center = center;
    [self addSubview:leftBtn];
    [logo release];
}

- (void)setTitle:(NSString *)text
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn = rightBtn;
    _rightBtn.frame = CGRectMake(kLeafMenuLeftBtnWidth + kLeafMenuPaddingLeft, 0.0f, 180.0f, kLeafMenuLeftBtnHeight);
    UILabel *title = [[UILabel alloc] init];
    [title setFont:kLeafFont19];
    CGSize size = [text sizeWithFont:kLeafFont19 constrainedToSize:CGSizeMake(160, kLeafMenuLeftBtnHeight)];
    title.textColor = [UIColor whiteColor];
    title.text = text;
    title.backgroundColor = [UIColor clearColor];
    [title setFrame:CGRectMake(kLeafMenuMarginX, 0.0f, size.width, size.height)];
    CGPoint center = title.center;
    center.y = kLeafMenuLeftBtnHeight/2.0f;
    [_rightBtn addSubview:title];
    title.center = center;
    [title release];
    [self addSubview:_rightBtn];
}

- (void)setColor:(UIColor *)color highlight:(UIColor *)hl
{
    [_leftBtn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [_leftBtn setBackgroundImage:[UIImage imageWithColor:hl] forState:UIControlStateHighlighted];
    
    [_rightBtn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [_rightBtn setBackgroundImage:[UIImage imageWithColor:hl] forState:UIControlStateHighlighted];

}

- (void)addTarget:(id)target action:(SEL)action
{
    [_leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

}

@end

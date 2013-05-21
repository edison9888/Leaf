//
//  LeafBottomBar.m
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafBottomBar.h"

#define kLeafBottomBtnMarginTop 5.0f
#define kLeafBottomBtnMarginLeft 15.0f
#define kLeafBottomBtnMarginRight 15.0f


@implementation LeafBottomBar
@synthesize leftItemType, midItemType, rightItemType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.image = [UIImage imageNamed:@"bottom_bg"];
        [self addSubview:bg];
        [bg release];
    }
    return self;
}

- (UIButton *)buttonWithType:(LeafBottomBarItemType)type
{
    NSString *imageName = nil;
    if (type == LeafBottomBarItemTypeBack) {
        imageName = @"bottom_icon_back";
    }
    else if(type == LeafBottomBarItemTypeReturn){
        imageName = @"bottom_icon_return";
    }
    else if(type == LeafBottomBarItemTypeComment){
        imageName = @"bottom_icon_comment";
    }
    else if(type == LeafBottomBarItemTypeShare)
    {
        imageName = @"bottom_icon_share";
    }
    else if(type == LeafBottomBarItemTypeWrite){
        imageName = @"bottom_icon_write";
    }
    else if(type == LeafBottomBarItemTypeSave){
        imageName = @"bottom_icon_save";
    }
    else if(type == LeafBottomBarItemTypeRefresh){
        imageName = @"bottom_icon_refresh";
    }

    if (!imageName) {
        NSLog(@"invalid bottom bar item type.");
        return nil;
    }
    
    UIImage *icon = [UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, 0.0f, icon.size.width, icon.size.height);
    [btn setImage:icon forState:UIControlStateNormal];
    return btn;
}


#pragma mark -
#pragma mark - Setters

- (void)setLeftItemType:(LeafBottomBarItemType)type
{
    UIButton *btn = [self buttonWithType:type];
    if (btn) {
        CGRect frame = btn.frame;
        frame.origin.x = kLeafBottomBtnMarginLeft;
        frame.origin.y = kLeafBottomBtnMarginTop;
        btn.frame = frame;
        [self addSubview:btn];
        _leftBtn = btn;
    }
}
- (void)setMidItemType:(LeafBottomBarItemType)type
{
    UIButton *btn = [self buttonWithType:type];
    if (btn) {
        CGRect frame = btn.frame;
        frame.origin.x = CGRectGetWidth(self.frame)/2.0 - CGRectGetWidth(frame)/2.0f;
        frame.origin.y = kLeafBottomBtnMarginTop;
        btn.frame = frame;
        [self addSubview:btn];
        _midBtn = btn;
    }
}

- (void)setRightItemType:(LeafBottomBarItemType)type
{
    UIButton *btn = [self buttonWithType:type];
    if (btn) {
        CGRect frame = btn.frame;
        frame.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(frame) -kLeafBottomBtnMarginRight;
        frame.origin.y = kLeafBottomBtnMarginTop;
        btn.frame = frame;
        [self addSubview:btn];
        _rightBtn = btn;
    }
}



#pragma mark -
#pragma mark - Targets and Actions

- (void)addLeftTarget:(id)target action:(SEL)action
{
    if (_leftBtn) {
        [_leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addMidTarget:(id)target action:(SEL)action
{
    if (_midBtn) {
        [_midBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addRightTarget:(id)target action:(SEL)action
{
    if (_rightBtn) {
        [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

@end

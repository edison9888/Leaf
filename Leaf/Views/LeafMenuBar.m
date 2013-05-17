
//  LeafMenuBar.m
//  Leaf
//
//  Created by roger on 13-5-16.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMenuBar.h"

#define kLeafMenuBarFrame CGRectMake(20.0f, 0.0f, 280.0f, 91.0f)
#define kLeafMenuBarItemMargin 1.8f
#define kLeafMenuBarContainerSize CGSizeMake(274.0f, 68.0f)
#define kLeafMenuBarContainerMarinLeft 3.0f
#define kLeafMenuBarContainerMarinTopUp 15.0f
#define kLeafMenuBarContainerMarinTopDown 4.0f

@interface LeafMenuBar ()
{
    UIView *_background;
    UIView *_container;
    UIImageView *_menubar;
    
    UIButton *_upBtn;
    UIButton *_downBtn;
    UIButton *_replyBtn;
    UIButton *_cpyBtn;

}

- (UIButton *)button:(CGFloat)x image:(UIImage *)image text:(NSString *)text type:(LeafMenuBarItemType)type;
- (void)hide;

@end


@implementation LeafMenuBar
@synthesize type = _type;
@synthesize offsetY = _offsetY;
@synthesize delegate = _delegate;

- (void)dealloc
{
    _background = nil;
    _container = nil;
    _menubar = nil;
    
    _upBtn = nil;
    _downBtn = nil;
    _replyBtn = nil;
    _cpyBtn = nil;
    _delegate = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *background = [[UIView alloc] initWithFrame:self.bounds];
        background.backgroundColor = [UIColor clearColor];
        _background = background;
        [self addSubview:background];
        [background release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_background addGestureRecognizer:tap];
        [tap release];
        
        UIImageView *menubar = [[UIImageView alloc] initWithFrame:kLeafMenuBarFrame];
        menubar.userInteractionEnabled = YES;
        _menubar = menubar;
        [self addSubview:menubar];
        [menubar release];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kLeafMenuBarContainerSize.width, kLeafMenuBarContainerSize.height)];
        _container = container;
        [_menubar addSubview:container];
        [container release];
        
        CGFloat x = 0.0f;
        UIButton *upBtn = [self button:x image:[UIImage imageNamed:@"menubar.bundle/icon_hand_up"] text:@"顶" type:LeafMenuBarItemTypeUp];
        _upBtn = upBtn;
        [_container addSubview:upBtn];
        
        x = CGRectGetMaxX(upBtn.frame) + kLeafMenuBarItemMargin;
        
        UIButton *downBtn = [self button:x image:[UIImage imageNamed:@"menubar.bundle/icon_hand_down"] text:@"踩" type:LeafMenuBarItemTypeDown];
        _downBtn = downBtn;
        [_container addSubview:downBtn];
        
        x = CGRectGetMaxX(downBtn.frame) + kLeafMenuBarItemMargin;
        
        UIButton *replyBtn = [self button:x image:[UIImage imageNamed:@"menubar.bundle/icon_reply"] text:@"回复" type:LeafMenuBarItemTypeReply];
        _replyBtn = replyBtn;
        [_container addSubview:replyBtn];
        
        x = CGRectGetMaxX(replyBtn.frame) + kLeafMenuBarItemMargin;
        
        
        UIButton *copyBtn = [self button:x image:[UIImage imageNamed:@"menubar.bundle/icon_copy"] text:@"复制" type:LeafMenuBarItemTypeCopy];
        _cpyBtn = copyBtn;
        [_container addSubview:copyBtn];
        self.type = LeafMenuBarArrowTypeDown;
    }
    return self;
}


- (void)setType:(LeafMenuBarArrowType)type
{
    _type = type;
    if (_type == LeafMenuBarArrowTypeDown) {
        [_menubar setImage:[UIImage imageNamed:@"menubar.bundle/menubar_bg_arrow_down"]];
        CGRect frame =  _container.frame;
        frame.origin.x = kLeafMenuBarContainerMarinLeft;
        frame.origin.y = kLeafMenuBarContainerMarinTopDown;
        _container.frame = frame;
    }
    else
    {
        [_menubar setImage:[UIImage imageNamed:@"menubar.bundle/menubar_bg_arrow_up"]];
        CGRect frame =  _container.frame;
        frame.origin.x = kLeafMenuBarContainerMarinLeft;
        frame.origin.y = kLeafMenuBarContainerMarinTopUp;
        _container.frame = frame;

    }
}

- (void)setOffsetY:(CGFloat)offsetY
{
    CGRect frame = _menubar.frame;
    frame.origin.y = offsetY;
    _menubar.frame = frame;
}

- (void)menuItemClicked:(UIButton *)sender
{
    [self hide];
    LeafMenuBarItemType type = sender.tag;
    if ([_delegate respondsToSelector:@selector(menuBar:didClickedItemWithType:)])
    {
        [_delegate menuBar:self didClickedItemWithType:type];
    }
}

- (void)tap:(UIGestureRecognizer *)recognizer
{
    [self hide];
}

- (void)show
{
    self.hidden = NO;
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:NULL];
}

- (void)hide
{
    self.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                     }];
}

- (UIButton *)button:(CGFloat)x image:(UIImage *)image text:(NSString *)text type:(LeafMenuBarItemType)type
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x, 0.0f, 67.0f, 68.0f);
    UIImage *itemBg = [UIImage imageNamed:@"menubar.bundle/menuitem_bg"];
    UIImage *resizeableItemBg = [itemBg resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 2.0f, 1.0f, 2.0f)];
    [btn setBackgroundImage:resizeableItemBg forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 27.0f, 26.0f)];
    [icon setImage:image];
    CGPoint center = CGPointMake(CGRectGetWidth(btn.frame)/2.0f, CGRectGetHeight(btn.frame)/2.0f);
    center.y -= 10.0f;
    icon.center = center;
    [btn addSubview:icon];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(icon.frame) + 8.0f, 67.0f, 15.0f)];
    label.font = kLeafFont15;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.userInteractionEnabled = NO;
    [btn addSubview:label];
    [label release];
    [icon release];
    return btn;
}


@end

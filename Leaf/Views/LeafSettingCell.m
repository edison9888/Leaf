//
//  LeafSettingCell.m
//  Leaf
//
//  Created by roger on 13-5-8.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafSettingCell.h"

#define kLeafSettingCellSize CGSizeMake(320.0f, 49.0f)
#define kLeafSettingCellTitleMarginLeft 30.0f
#define kLeafSettingCellArrowMarginRight 32.0f
@interface LeafSettingCell ()
{
    UIButton *_item;
    UIImageView *_arrow;
}

@end


@implementation LeafSettingCell
@synthesize hasArrow = _hasArrow;
@synthesize simple = _simple;


- (void)dealloc
{
    _item = nil;
    _arrow = nil;
    
    [super dealloc];
}

- (void)setOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (void)setTitle:(NSString *)text
{
    CGSize size = [text sizeWithFont:kLeafFont15 constrainedToSize:kLeafSettingCellSize];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    title.font = kLeafFont15;
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    title.text = text;
    
    CGPoint center = CGPointMake(size.width/2.0f + kLeafSettingCellTitleMarginLeft, kLeafSettingCellSize.height/2.0f);
    title.center = center;
    [self addSubview:title];
    [title release];
}

- (void)setSimple:(BOOL)simple
{
    _simple = simple;
    if (_simple) {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kLeafSettingCellSize.width, kLeafSettingCellSize.height)];
        [bg setImage:[UIImage imageNamed:@"settingcell_bg"]];
        [self addSubview:bg];
        [bg release];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    UIImage *bg = [UIImage imageNamed:@"settingcell_bg"];
    UIImage *bg_selected = [UIImage imageNamed:@"settingcell_bg_selected"];
    _item = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0f, 0.0f, kLeafSettingCellSize.width, kLeafSettingCellSize.height);
    self.frame = frame;
    _item.frame = frame;
    [_item setBackgroundImage:bg forState:UIControlStateNormal];
    [_item setBackgroundImage:bg_selected forState:UIControlStateHighlighted];
    
    [self addSubview:_item];
    [_item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.hasArrow = YES;
}


- (void)setHasArrow:(BOOL)hasArrow
{
    _hasArrow = hasArrow;
    if (_hasArrow) {
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingcell_arrow"]];
        _arrow = arrow;
        [_item addSubview:_arrow];
        [arrow release];
        
        CGPoint point = CGPointMake(kLeafSettingCellSize.width - kLeafSettingCellArrowMarginRight, kLeafSettingCellSize.height/2.0f);
        _arrow.center = point;
    }
}


@end

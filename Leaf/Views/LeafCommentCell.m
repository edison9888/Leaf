//
//  LeafCommentCell.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCommentCell.h"
#import "UIColor+MLPFlatColors.h"

#define kLeafCommentFont [UIFont fontWithName:@"FZLTHK--GBK1-0" size:13.0f]
#define kLeafCommentDateFont [UIFont fontWithName:@"FZLTHK--GBK1-0" size:11.0f]
#define kLeafCommentDefaultHeight 20.0f
#define kLeafCommentDefaultWidth 160.0f
#define kLeafCommentWidth 290.0f
#define kLeafCommentMaxSize CGSizeMake(kLeafCommentWidth, 640.0f)
#define kLeafCommentHeadMaxSize CGSizeMake(135.0f, 15.0f)
#define kLeafCommentMarginTop 12.0f
#define kLeafCommentMarginBottom 30.0f
#define kLeafCommentMarginX 15.0f
#define kLeafCommentChildMarginX 30.0f
#define kLeafCommentHeadMarginY 12.0f
#define kLeafCommentHeadMarginX 15.0f
#define kLeafCommentHeadHeight 15.0f
#define kLeafCommentMaxLines 22
#define kLeafCommentChildWidth 270.0f
#define kLeafCommentChildMaxSize CGSizeMake(kLeafCommentChildWidth, 640.0f)
#define kLeafCommentChildHeadMaxSize CGSizeMake(kLeafCommentChildWidth, 15.0f)
#define kLeafCommentSeparatorWidth 290.0f
#define kLeafCommentChildSeparatorWidth 270.0f

#define kLeafCommentNameColor      [UIColor colorWithRed:CGColorConvert(140.0f) green:CGColorConvert(196.0f) blue:CGColorConvert(216.0f) alpha:1.0f]
#define KLeafCommentDateColor      [UIColor colorWithRed:CGColorConvert(140.0f) green:CGColorConvert(140.0f) blue:CGColorConvert(140.0f) alpha:1.0f]
#define kLeafCommentContentColor      [UIColor colorWithRed:CGColorConvert(51.0f) green:CGColorConvert(51.0f) blue:CGColorConvert(51.0f) alpha:1.0f]


@interface LeafCommentItem ()
{
@private
    UIView *_head;
    UILabel *_name;
    UILabel *_time;
    UILabel *_comment;
    UIView *_separator;
    UIImageView *_like;
    UILabel *_support;
    UIImageView *_unlike;
    UILabel *_against;

}

+ (CGSize)sizeForString:(NSString *)text style:(LeafCommentItemStyle)style;

@end

@implementation LeafCommentItem

- (void)dealloc
{
    _head = nil;
    _name = nil;
    _time = nil;
    _comment = nil;
    _like = nil;
    _support = nil;
    _unlike = nil;
    _against = nil;
    
    [super dealloc];
}

+ (CGFloat)heightForComment:(NSString *)comment style:(LeafCommentItemStyle)style
{
    CGSize size = [self sizeForString:comment style:style];
    CGFloat textHeight = size.height;
    return (textHeight + kLeafCommentMarginTop + kLeafCommentMarginBottom + kLeafCommentHeadHeight + kLeafCommentHeadMarginY);
}

+ (CGSize)sizeForString:(NSString *)text style:(LeafCommentItemStyle)style
{
    CGSize size = CGSizeZero;
    if (!text) {
        return CGSizeZero;
    }
    
    if (style == LeafCommentItemStyleCurrent) {
        size = [text sizeWithFont:kLeafCommentFont constrainedToSize:kLeafCommentMaxSize];
    
    } else {
        size = [text sizeWithFont:kLeafCommentFont constrainedToSize:kLeafCommentChildMaxSize];
    }
    
    return size;
}


+ (CGFloat)widthForString:(NSString *)text withFont:(UIFont *)font
{
    if (!text) {
        return kLeafCommentDefaultWidth;
    }
    
    CGSize size = [text sizeWithFont:font constrainedToSize:kLeafCommentHeadMaxSize];
    return size.width;
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(kLeafCommentHeadMarginX, kLeafCommentHeadMarginY,  320.0f - 2 * kLeafCommentHeadMarginX, kLeafCommentHeadHeight)];
        [self addSubview:head];
        _head = head;
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectZero];
        name.font = kLeafCommentFont;
        name.backgroundColor = [UIColor clearColor];
        _name = name;
        _name.textColor = kLeafCommentNameColor;
        [head addSubview:name];
        [name release];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectZero];
        time.font = kLeafCommentDateFont;
        time.backgroundColor = [UIColor clearColor];
        _time = time;
        _time.textColor = KLeafCommentDateColor;
        [head addSubview:time];
        [time release];
        [head release];
        
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectZero];
        comment.font = kLeafCommentFont;
        comment.backgroundColor = [UIColor clearColor];
        _comment = comment;
        _comment.textColor = kLeafCommentContentColor;
        [_comment setLineBreakMode:UILineBreakModeWordWrap];
        [_comment setNumberOfLines:kLeafCommentMaxLines];
        
        [self addSubview:comment];
        [comment release];
        
        UIImageView *like = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like"]];
        like.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
        _like = like;
        [self addSubview:like];
        [like release];
        
        UILabel *support = [[UILabel alloc] initWithFrame:CGRectMake(0.0f , 0.0f, 39.0f, 15.0f)];
        support.backgroundColor = [UIColor clearColor];
        support.font = kLeafFont13;
        support.textColor = [UIColor flatDarkGreenColor];
        _support = support;
        [self addSubview:support];
        [support release];
        
        
        UIImageView *unlike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unlike"]];
        unlike.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
        _unlike = unlike;
        [self addSubview:unlike];
        [unlike release];
        
        UILabel *against = [[UILabel alloc] initWithFrame:CGRectMake(0.0f , 0.0f, 45.0f, 15.0f)];
        against.backgroundColor = [UIColor clearColor];
        against.font = kLeafFont13;
        against.textColor = [UIColor flatDarkRedColor];
        _against = against;
        [self addSubview:against];
        [against release];
        
        UIView *separator = [[UIView alloc] init];
        _separator = separator;
        [self addSubview:_separator];
        [separator release];
        
    }
    return self;
}

- (void) loadData:(LeafCommentData *)data style:(LeafCommentItemStyle)style
{
    NSString *name = data.name;
    NSString *time = data.time;
    NSString *comment = data.comment;
    CGFloat marginX = 0.0f;
    CGFloat width = 0.0f;
    
    marginX = (style == LeafCommentItemStyleCurrent? kLeafCommentMarginX : kLeafCommentChildMarginX);
    
    CGRect headFrame = _head.frame;
    headFrame.origin.x = marginX;
    headFrame.size.width = (style == LeafCommentItemStyleCurrent? kLeafCommentWidth : kLeafCommentChildWidth);
    _head.frame = headFrame;

    width = [LeafCommentItem widthForString:name withFont:kLeafCommentFont];
    [_name setText:name];
    [_name setFrame:CGRectMake(0.0f, 0.0f, width, kLeafCommentHeadHeight)];
    
    width = [LeafCommentItem widthForString:time withFont:kLeafCommentDateFont];
    [_time setText:time];
    [_time setFrame:CGRectMake(CGRectGetWidth(_head.frame) - kLeafCommentHeadMarginX - width, 0.0f, width, kLeafCommentHeadHeight)];
    
    CGSize commentSize = [LeafCommentItem sizeForString:comment style:style];
    [_comment setText:comment];
    [_comment setFrame:CGRectMake(marginX, kLeafCommentMarginTop + kLeafCommentHeadMarginY + kLeafCommentHeadHeight, commentSize.width, commentSize.height)];
    
    CGFloat height = [LeafCommentItem heightForComment:comment style:style];
    [self setFrame:CGRectMake(0.0f, 0.0f, 320.0f, height)];
    
    _like.frame = CGRectMake(320.0f - 116.0f, height - 18.0f, 15.0f, 15.0f);
    _support.frame = CGRectMake(CGRectGetMaxX(_like.frame) + 3.0f, height - 15.0f, 39.0f, 13.0f);
    _support.text = data.support;
    
    
    _unlike.frame = CGRectMake(320.0f - 66.0f, height - 18.0f, 15.0f, 15.0f);
    _against.frame = CGRectMake(CGRectGetMaxX(_unlike.frame) + 3.0f, height - 15.0f, 39.0f, 13.0f);
    _against.text = data.against;
    
    CGFloat separatorWidth = (style == LeafCommentItemStyleCurrent? kLeafCommentSeparatorWidth : kLeafCommentChildSeparatorWidth);
    [_separator setFrame:CGRectMake(marginX, height - 1.0f, separatorWidth, 1.0f)];
    UIColor *backColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dot_border"]];
    _separator.backgroundColor = backColor;
    
    
   
}

@end

#pragma mark -
#pragma mark - LeafCommentCell


@interface LeafCommentCell ()
{
    LeafCommentItem *_current;
    LeafCommentItem *_child;
}


@end
    
@implementation LeafCommentCell
@synthesize delegate = _delegate;
- (void)dealloc
{
    _current = nil;
    _child = nil;
    _delegate = nil;
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCurrent:)];
        _current = [[LeafCommentItem alloc] init];
        [_current addGestureRecognizer:tap];
        [tap release];
        [self addSubview:_current];
        _child = nil;
    }
    
    return self;
}


#pragma mark -

- (void)tapCurrent:(UITapGestureRecognizer *)recognizer
{
    LeafCommentItem *item = (LeafCommentItem *)recognizer.view;
    if (_delegate && [_delegate respondsToSelector:@selector(leafCommentItemTapped:)]) {
        [_delegate leafCommentItemTapped:item];
    }
}

- (void)tapChild:(UITapGestureRecognizer *)recognizer
{
    LeafCommentItem *item = (LeafCommentItem *)recognizer.view;
    if (_delegate && [_delegate respondsToSelector:@selector(leafCommentItemTapped:)]) {
        [_delegate leafCommentItemTapped:item];
    }
}

+ (CGFloat)heightForComment:(LeafCommentData *)data
{
    CGFloat height = 0.0f;
    
    if (data.parent) {
        LeafCommentData *parent = data.parent;
        height += [LeafCommentItem heightForComment:parent.comment style:LeafCommentItemStyleCurrent];
        height += [LeafCommentItem heightForComment:data.comment style:LeafCommentItemStyleChild];
    }
    else
    {
        height = [LeafCommentItem heightForComment:data.comment style:LeafCommentItemStyleCurrent];
    }
    
    return height;
}


- (void) loadData:(LeafCommentData *)data
{
    if (!data) {
        NSLog(@"error: LeafCommentCell ==> data is nil.");
        return;
    }
    
    LeafCommentData *parent = data.parent;
    
    if (parent) {
        [_current loadData:parent style:LeafCommentItemStyleCurrent];
        
        if (!_child) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChild:)];
            LeafCommentItem *child = [[LeafCommentItem alloc] init];
            [child addGestureRecognizer:tap];
            [tap release];
            [self addSubview:child];
            _child = child;
            [child release];
        }
        [_child loadData:data style:LeafCommentItemStyleChild];
        CGRect frame = _child.frame;
        frame.origin.y = CGRectGetHeight(_current.frame);
        _child.frame = frame;
        
        CGFloat height = CGRectGetHeight(_current.frame) + CGRectGetHeight(_child.frame);
        self.frame = CGRectMake(0.0f, 0.0f, 320.0f, height);
        return;
    }
    
    if (_child) {
        [_child removeFromSuperview];
        _child = nil;
    }
    
    [_current loadData:data style:LeafCommentItemStyleCurrent];
    CGFloat height = CGRectGetHeight(_current.frame);
    self.frame = CGRectMake(0.0f, 0.0f, 320.0f, height);
}

@end

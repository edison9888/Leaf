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
#define kLeafCommentMaxSize CGSizeMake(kLeafCommentWidth, 320.0f)
#define kLeafCommentHeadMaxSize CGSizeMake(kLeafCommentWidth, 15.0f)
#define kLeafCommentMarginTop 12.0f
#define kLeafCommentMarginBottom 30.0f
#define kLeafCommentMarginX 15.0f
#define kLeafCommentHeadMarginY 12.0f
#define kLeafCommentHeadMarginX 15.0f
#define kLeafCommentHeadHeight 15.0f
#define kLeafCommentMaxLines 22

#define kLeafCommentNameColor      [UIColor colorWithRed:CGColorConvert(140.0f) green:CGColorConvert(196.0f) blue:CGColorConvert(216.0f) alpha:1.0f]
#define KLeafCommentDateColor      [UIColor colorWithRed:CGColorConvert(140.0f) green:CGColorConvert(140.0f) blue:CGColorConvert(140.0f) alpha:1.0f]
#define kLeafCommentContentColor      [UIColor colorWithRed:CGColorConvert(51.0f) green:CGColorConvert(51.0f) blue:CGColorConvert(51.0f) alpha:1.0f]


@interface LeafCommentCell ()
{
    @private
    UILabel *_name;
    UILabel *_time;
    UILabel *_comment;
    UIImageView *_separator;
    UIImageView *_like;
    UILabel *_support;
    UIImageView *_unlike;
    UILabel *_against;
}

+ (CGSize)sizeForString:(NSString *)text;

@end

@implementation LeafCommentCell

- (void)dealloc
{
    _name = nil;
    _time = nil;
    _comment = nil;
    _like = nil;
    _support = nil;
    _unlike = nil;
    _against = nil;
    
    [super dealloc];
}

+ (CGFloat)heightForComment:(NSString *)comment
{
    CGSize size = [self sizeForString:comment];
    CGFloat textHeight = size.height;
    return (textHeight + kLeafCommentMarginTop + kLeafCommentMarginBottom + kLeafCommentHeadHeight + kLeafCommentHeadMarginY);
}

+ (CGSize)sizeForString:(NSString *)text
{
    if (!text) {
        return CGSizeZero;
    }
    
    CGSize size = [text sizeWithFont:kLeafCommentFont constrainedToSize:kLeafCommentMaxSize];
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
        
        UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_line"]];
        _separator = separator;
        [self addSubview:_separator];
        [separator release];
        
    }
    return self;
}

- (void) loadData:(NSDictionary *)info
{
    NSString *name = [info stringForKey:@"name"];
    NSString *time = [info stringForKey:@"time"];
    NSString *comment = [info stringForKey:@"comment"];
    
    CGFloat width = 0.0f;
    width = [LeafCommentCell widthForString:name withFont:kLeafCommentFont];
    [_name setText:name];
    [_name setFrame:CGRectMake(0.0f, 0.0f, width, kLeafCommentHeadHeight)];
    
    width = [LeafCommentCell widthForString:time withFont:kLeafCommentDateFont];
    [_time setText:time];
    [_time setFrame:CGRectMake(320.0f - 2 * kLeafCommentHeadMarginX - width, 0.0f, width, kLeafCommentHeadHeight)];
    
    CGSize commentSize = [LeafCommentCell sizeForString:comment];
    [_comment setText:comment];
    [_comment setFrame:CGRectMake(kLeafCommentMarginX, kLeafCommentMarginTop + kLeafCommentHeadMarginY + kLeafCommentHeadHeight, commentSize.width, commentSize.height)];
        
    CGFloat height = [LeafCommentCell heightForComment:comment];
    [self setFrame:CGRectMake(0.0f, 0.0f, 320.0f, height)];
    
    _like.frame = CGRectMake(320.0f - 116.0f, height - 18.0f, 15.0f, 15.0f);
    _support.frame = CGRectMake(CGRectGetMaxX(_like.frame) + 3.0f, height - 15.0f, 39.0f, 13.0f);
    _support.text = [info stringForKey:@"support"];
    
    
    _unlike.frame = CGRectMake(320.0f - 66.0f, height - 18.0f, 15.0f, 15.0f);
    _against.frame = CGRectMake(CGRectGetMaxX(_unlike.frame) + 3.0f, height - 15.0f, 39.0f, 13.0f);
    _against.text = [info stringForKey:@"against"];
    
    [_separator setFrame:CGRectMake(kLeafCommentMarginX, height - 1.0f, kLeafCommentWidth, 1.0f)];
}

@end

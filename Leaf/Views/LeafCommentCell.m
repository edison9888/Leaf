//
//  LeafCommentCell.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCommentCell.h"


#define kLeafCommentFont [UIFont fontWithName:@"FZLTHK--GBK1-0" size:13.0f]
#define kLeafCommentDateFont [UIFont fontWithName:@"FZLTHK--GBK1-0" size:11.0f]
#define kLeafCommentDefaultHeight 20.0f
#define kLeafCommentDefaultWidth 160.0f
#define kLeafCommentWidth 290.0f
#define kLeafCommentMaxSize CGSizeMake(kLeafCommentWidth, 320.0f)
#define kLeafCommentHeadMaxSize CGSizeMake(kLeafCommentWidth, 15.0f)
#define kLeafCommentMarginY 12.0f
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
}

+ (CGSize)sizeForString:(NSString *)text;

@end

@implementation LeafCommentCell

- (void)dealloc
{
    _name = nil;
    _time = nil;
    _comment = nil;
    [super dealloc];
}

+ (CGFloat)heightForComment:(NSString *)comment
{
    CGSize size = [self sizeForString:comment];
    CGFloat textHeight = size.height;
    return (textHeight + (2 * kLeafCommentMarginY) + kLeafCommentHeadHeight + kLeafCommentHeadMarginY);
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
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(kLeafCommentHeadMarginX, kLeafCommentMarginY,  320.0f - 2 * kLeafCommentHeadMarginX, kLeafCommentHeadHeight)];
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
    [_comment setFrame:CGRectMake(kLeafCommentMarginX, kLeafCommentMarginY + kLeafCommentHeadMarginY + kLeafCommentHeadHeight, commentSize.width, commentSize.height)];
        
    CGFloat height = [LeafCommentCell heightForComment:comment];
    [self setFrame:CGRectMake(0.0f, 0.0f, 320.0f, height)];
    
    [_separator setFrame:CGRectMake(kLeafCommentMarginX, height - 1.0f, kLeafCommentWidth, 1.0f)];
}

@end

//
//  LeafNewsItem.m
//  Leaf
//
//  Created by roger qian on 13-1-28.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LeafNewsItem.h"
#import "LeafNewsData.h"
#import "LeafCommentBox.h"
#import "LeafHelper.h"
#import "UIImageView+WebCache.h"

#define kMaxLines       3
#define kCellTitleFont  [UIFont fontWithName:@"FZLTZHK--GBK1-0" size:15.0f]
#define kCellTimeFont   [UIFont fontWithName:@"FZLTHK--GBK1-0" size:10.0f]
#define kMidTitleSize   CGSizeMake(188.0f, 56.0f)
#define kMidTimeSize    CGSizeMake(188.0f, 10.0f)
#define kMaxTitleSize   CGSizeMake(266.0f, 56.0f)
#define kMaxTimeSize    CGSizeMake(266.0f, 10.0f)
#define kPaddingTime    2.0f
#define kPaddingTheme   10.0f
@implementation LeafNewsItem

- (void)dealloc
{
    _theme = nil;
    _title = nil;
    _time = nil;
    _box = nil;
    _content = nil;
    [super dealloc];
}


- (id)init
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 102.0f)]) {
        UIImageView *theme = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 10.0f, 78.0f, 78.0f)];
        _theme = theme;       

        [self addSubview:_theme];
        [theme release];
        
        LeafCommentBox *box = [[LeafCommentBox alloc] init];
        _box = box;
        _box.center = CGPointMake(298.0f, 16.0f);
        [self addSubview:_box];
        [box release];
        
        UIView *content = [[UIView alloc] init];
        _content = content;
        [self addSubview:content];
        [content release];
        
        UILabel *title = [[UILabel alloc] init];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setFont:kCellTitleFont];
        [title setLineBreakMode:UILineBreakModeWordWrap];
        [title setNumberOfLines:kMaxLines];
        [title setTextColor:[UIColor blackColor]];
        [_content addSubview:title];
        _title = title;
        [title release];
        
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:kCellTimeFont];        
        [label setTextColor:[UIColor blackColor]];
        [_content addSubview:label];
        _time = label;
        [label release];
        
        UIImageView *seprator  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep_line"]];
        seprator.center = CGPointMake(CGWidth(self.frame)/2.0f, CGHeight(self.frame)- 1.0f);
        [self addSubview:seprator];
        [seprator release];
    }
    
    return self;
}

- (void)loadData:(LeafNewsData *)data withStyle:(LeafItemStyle)style
{
    if (!data) {
        NSLog(@"leaf item, data is nil.");
        return;
    }
    CGFloat offsetY = 0.0f;
    
    if (style == LeafItemStyleFull) {
        CGSize size = [data.title sizeWithFont:kCellTitleFont constrainedToSize:kMidTitleSize lineBreakMode:_title.lineBreakMode];
        [_title setFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        [_title setText:data.title];
        offsetY += size.height + kPaddingTime;
        CGSize timeSize = [data.pubTime sizeWithFont:kCellTimeFont constrainedToSize:kMidTimeSize];
        [_time setText:data.pubTime];
        [_time setFrame:CGRectMake(0.0f, CGOriginY(_title.frame) + CGHeight(_title.frame) + 2.0f, timeSize.width, timeSize.height)];
        offsetY += timeSize.height;
        [_theme setHidden:NO];
        if (data.theme && [data.theme hasPrefix:@"http://"] && 
            (![[data.theme lowercaseString] hasSuffix:@".gif"])) {                       
            [_theme setImageWithURL:[NSURL URLWithString:data.theme] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
        else{
            [_theme setImage:[UIImage imageNamed:@"placeholder"]];
        }
        
        CGFloat originX = CGOriginX(_theme.frame) + CGWidth(_theme.frame) + kPaddingTheme;
        CGFloat originY = (CGHeight(self.frame) - offsetY)/2.0f;
        [_content setFrame:CGRectMake(originX, originY, size.width, offsetY)];
    }    
    else {       
        [_theme setHidden:YES];
        CGSize size = [data.title sizeWithFont:kCellTitleFont constrainedToSize:kMaxTitleSize lineBreakMode:_title.lineBreakMode];
        [_title setFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        [_title setText:data.title];
        offsetY += size.height + kPaddingTime;
        CGSize timeSize = [data.pubTime sizeWithFont:kCellTimeFont constrainedToSize:kMaxTimeSize];
        [_time setText:data.pubTime];
        [_time setFrame:CGRectMake(0.0f, CGOriginY(_title.frame) + CGHeight(_title.frame) + 2.0f, timeSize.width, timeSize.height)];
        offsetY += timeSize.height;
        
        CGFloat originX = kPaddingTheme;
        CGFloat originY = (CGHeight(self.frame) - offsetY)/2.0f;
        [_content setFrame:CGRectMake(originX, originY, size.width, offsetY)];
            
    }
    
    
    
    [_box setText:data.cmtNum];
}

@end

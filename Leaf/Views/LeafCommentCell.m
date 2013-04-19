//
//  LeafCommentCell.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCommentCell.h"

#define kLeafCommentFont [UIFont fontWithName:@"FZLTHK--GBK1-0" size:13.0f]
#define kLeafCommentDefaultHeight 20.0f
#define kLeafCommentWidth 300.0f
#define kLeafCommentMaxSize CGSizeMake(kLeafCommentWidth, 320.0f)
#define kLeafCommentMargin 10.0f
#define kLeafCommentTitleHeight 15.0f

@interface LeafCommentCell ()

+ (CGFloat)heightForString:(NSString *)text;
@end

@implementation LeafCommentCell

+ (CGFloat)heightForComment:(NSString *)comment
{
    CGFloat textHeight = [self heightForString:comment];
    return (textHeight + (2 * kLeafCommentMargin) + kLeafCommentTitleHeight);
}

+ (CGFloat)heightForString:(NSString *)text
{
    if (!text) {
        return kLeafCommentDefaultHeight;
    }
    
    CGSize size = [text sizeWithFont:kLeafCommentFont constrainedToSize:kLeafCommentMaxSize];
    return size.height;
}


- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (void) loadData:(NSDictionary *)info
{
    
}

@end

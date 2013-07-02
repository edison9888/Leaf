//
//  LeafNewsItem.h
//  Leaf
//
//  Created by roger qian on 13-1-28.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LeafItemStyleNone = 0,
    LeafItemStyleSimple,
    LeafItemStyleFull
}LeafItemStyle;

@class LeafCommentBox, LeafNewsData;
@interface LeafNewsItem : UIView
{
    UIImageView *_theme;
    UILabel *_title;
    UILabel *_time;
    LeafCommentBox *_box;
    UIView *_content;
    UIImageView *_seprator;
}

- (void)loadData:(LeafNewsData *)data withStyle:(LeafItemStyle)style;
- (void)updateReadStatus:(NSString *)articleId;

@end

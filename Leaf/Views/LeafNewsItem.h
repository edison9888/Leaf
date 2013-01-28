//
//  LeafNewsItem.h
//  Leaf
//
//  Created by roger qian on 13-1-28.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeafCommentBox, LeafNewsData;
@interface LeafNewsItem : UIView
{
    UIImageView *_theme;
    UILabel *_title;
    UILabel *_time;
    LeafCommentBox *_box;
    UIView *_content;
}

- (void)loadData:(LeafNewsData *)data;

@end

//
//  LeafCommentCell.h
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeafCommentData.h"

typedef enum {
    LeafCommentItemStyleChild = 0,
    LeafCommentItemStyleCurrent
}LeafCommentItemStyle;

@interface LeafCommentItem : UIView

+ (CGFloat)heightForComment:(NSString *)comment style:(LeafCommentItemStyle)style;
- (void) loadData:(LeafCommentData *)info style:(LeafCommentItemStyle)style;

@end

@interface LeafCommentCell : UIView
+ (CGFloat)heightForComment:(LeafCommentData *)data;
- (void) loadData:(LeafCommentData *)data;
@end

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
{
    LeafCommentData *_data;
}

@property (nonatomic, retain) LeafCommentData *data;

+ (CGFloat)heightForComment:(NSString *)comment style:(LeafCommentItemStyle)style;
- (void) loadData:(LeafCommentData *)info style:(LeafCommentItemStyle)style;

@end

@protocol LeafCommentCellDelegate;

@interface LeafCommentCell : UIView
{
    NSObject <LeafCommentCellDelegate> *_delegate;
}

@property (nonatomic, assign) NSObject <LeafCommentCellDelegate> *delegate;

+ (CGFloat)heightForComment:(LeafCommentData *)data;
- (void) loadData:(LeafCommentData *)data;
@end

@protocol LeafCommentCellDelegate <NSObject>

@optional
- (void)leafCommentItemTapped:(LeafCommentItem *)item;

@end




//
//  LeafCommentCell.h
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafCommentCell : UIView
+ (CGFloat)heightForComment:(NSString *)comment;
- (void) loadData:(NSDictionary *)info;
@end

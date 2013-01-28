//
//  LeafCommentBox.h
//  Leaf
//
//  Created by roger qian on 13-1-28.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LeafColorTypeGreen = 0,
    LeafColorTypeBlue,
    LeafColorTypePureBlue,
    LeafColorTypeLightGreen,
    LeafColorTypeYellow    
}LeafColorType;

@interface LeafCommentBox : UIView
{
    UIImageView *_colorful;
    UILabel *_count;
    CGPoint _center;
}


- (void)setText:(NSString *)count;
@end

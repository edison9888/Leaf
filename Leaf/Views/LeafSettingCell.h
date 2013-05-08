//
//  LeafSettingCell.h
//  Leaf
//
//  Created by roger on 13-5-8.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafSettingCell : UIView
{
    BOOL _simple;
    BOOL _hasArrow;
}

@property (nonatomic, assign) BOOL simple;
@property (nonatomic, assign) BOOL hasArrow;

- (void)setTitle:(NSString *)text;
- (void)setOrigin:(CGPoint)point;
- (void)addTarget:(id)target action:(SEL)action;

@end

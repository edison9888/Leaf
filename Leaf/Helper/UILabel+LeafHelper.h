//
//  UILabel+LeafHelper.h
//  Leaf
//
//  Created by roger qian on 12-12-20.
//  Copyright (c) 2012年 Mobimtech. All rights reserved.
//


@interface UILabel (LeafHelper)

- (id) initWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color andOrigin:(CGPoint)origin;

- (id) initWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color andOrigin:(CGPoint)origin constrainedToSize:(CGSize)size;
@end

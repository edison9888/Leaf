//
//  UILabel+LeafHelper.m
//  Leaf
//
//  Created by roger qian on 12-12-20.
//  Copyright (c) 2012年 Mobimtech. All rights reserved.
//

#import "UILabel+LeafHelper.h"

@implementation UILabel (LeafHelper)


- (id) initWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color andOrigin:(CGPoint)origin
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setFont:font];
        CGSize text_size = [text sizeWithFont:font];
        [self setText:text];
        [self setTextColor:color];
        [self setFrame:CGRectMake(origin.x, origin.y, text_size.width, text_size.height)];
    }    
    return self;
}

- (id) initWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color andOrigin:(CGPoint)origin constrainedToSize:(CGSize)size
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setFont:font];
        CGSize text_size = [text sizeWithFont:font constrainedToSize:size];
        [self setText:text];
        [self setTextColor:color];
        [self setFrame:CGRectMake(origin.x, origin.y, text_size.width, text_size.height)];
    }    
    return self;
}

@end

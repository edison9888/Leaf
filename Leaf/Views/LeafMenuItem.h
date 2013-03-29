//
//  LeafMenuItem.h
//  Leaf
//
//  Created by roger qian on 13-3-29.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafMenuItem : UIView
{
    UILabel *_title;
    UIImageView *_logo;
    UIColor *_color;
}

@property (nonatomic, retain) UIColor *color;

- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)text highlight:(UIColor *)color;

@end

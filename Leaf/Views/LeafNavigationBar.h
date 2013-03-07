//
//  LeafNavigationBar.h
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LeafNavigationItemStyleNone = 0,
    LeafNavigationItemStyleMenu,
    LeafNavigationItemStyleBack,
    LeafNavigationItemStyleRefresh,
    LeafNavigationItemStyleSafari,
    LeafNavigationItemStyleShare    
}LeafNavigationItemStyle;

@interface LeafNavigationBar : UIView
{
    UIImageView *_leftIcon;
    UIButton *_leftBtn;
    UIImageView *_rightIcon;
    UIButton *_rightBtn;
}

- (void) addLeftItemWithStyle:(LeafNavigationItemStyle)style target:(id)target action:(SEL)action;
- (void) addRightItemWithStyle:(LeafNavigationItemStyle)style target:(id)target action:(SEL)action;
- (void) setTitle:(NSString *)title;
@end

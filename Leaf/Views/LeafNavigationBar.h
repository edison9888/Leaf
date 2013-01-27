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
    LeafNavigationItemStyleHome,
    LeafNavigationItemStyleRefresh,
    LeafNavigationItemStyleSafari,
    LeafNavigationItemStyleShare    
}LeafNavigationItemStyle;

@interface LeafNavigationBar : UIView
{
    
}

- (void) addItemWithStyle:(LeafNavigationItemStyle)style target:(id)target action:(SEL)action;
@end

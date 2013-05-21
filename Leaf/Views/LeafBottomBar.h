//
//  LeafBottomBar.h
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LeafBottomBarItemTypeReturn,
    LeafBottomBarItemTypeBack,
    LeafBottomBarItemTypeShare,
    LeafBottomBarItemTypeComment,
    LeafBottomBarItemTypeWrite,
    LeafBottomBarItemTypeSave,
    LeafBottomBarItemTypeRefresh
} LeafBottomBarItemType;

@interface LeafBottomBar : UIView
{
    @private
    UIButton *_leftBtn;
    UIButton *_midBtn;
    UIButton *_rightBtn;
}

@property (nonatomic, assign) LeafBottomBarItemType leftItemType;
@property (nonatomic, assign) LeafBottomBarItemType midItemType;
@property (nonatomic, assign) LeafBottomBarItemType rightItemType;

- (void)addLeftTarget:(id)target action:(SEL)action;
- (void)addMidTarget:(id)target action:(SEL)action;
- (void)addRightTarget:(id)target action:(SEL)action;

@end

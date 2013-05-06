//
//  LeafBottomBar.h
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafBottomBar : UIView
{
    @private
    UIButton *_returnBtn;
    UIButton *_saveBtn;
}

- (void)addLeftTarget:(id)target action:(SEL)action;
- (void)addRightTarget:(id)target action:(SEL)action;

@end

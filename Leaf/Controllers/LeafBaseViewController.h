//
//  LeafBaseViewController.h
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LeafAnimationOptionHorizontal = 0,
    LeafAnimationOptionVertical
}LeafAnimationOption;

@interface LeafBaseViewController : UIViewController
{
    UIView *_container;
    UIView *_mask;
}

- (void)presentViewController:(UIViewController *)controller option:(LeafAnimationOption)option;
- (void)dismissViewControllerWithOption:(LeafAnimationOption)option;

@end

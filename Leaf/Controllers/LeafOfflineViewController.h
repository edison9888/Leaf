//
//  LeafOfflineViewController.h
//  Leaf
//
//  Created by roger on 13-4-24.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafOfflineViewController : LeafBaseViewController
{
    BOOL _downloadAtOnce;
}

@property (nonatomic, assign) BOOL downloadAtOnce;

@end

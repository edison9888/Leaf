//
//  AppDelegate.h
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppKey             @"2903127267"
#define kAppSecret          @"59d9eff25b9d076c170586c3789bc2bd"
#define kAppRedirectURI     @"http://weibo.com/u/1847878591"


@class DDMenuController;
@class SinaWeibo;
@class LeafMainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    SinaWeibo *_weibo;
    DDMenuController *_menuController;
    LeafMainViewController *_mainController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) SinaWeibo *weibo;
@property (nonatomic, retain) DDMenuController *menuController;
@property (nonatomic, retain) LeafMainViewController *mainController;
@end

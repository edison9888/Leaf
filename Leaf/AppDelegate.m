//
//  AppDelegate.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "AppDelegate.h"
#import "LeafMainViewController.h"
#import "LeafMenuController.h"
#import "DDMenuController.h"
#import "SinaWeibo.h"


@implementation AppDelegate

@synthesize weibo = _weibo;
@synthesize window = _window;
@synthesize menuController = _menuController;
@synthesize mainController = _mainController;


- (void)dealloc
{
    [_window release];
    [_weibo release]; _weibo = nil;
    [_menuController release], _menuController = nil;
    [_mainController release], _mainController = nil;
    [_leftController release], _leftController = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    LeafMainViewController *mainController = [[LeafMainViewController alloc] init];
    self.mainController = mainController;
    _leftController = [[LeafMenuController alloc] init];
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:mainController];
    self.menuController = rootController;
    rootController.leftViewController = _leftController;
    
    self.window.rootViewController = rootController;

    [mainController release];
    
    [rootController release];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // weibo stuff
    
    _weibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI ssoCallbackScheme:@"org.roger.leaf" andDelegate:_mainController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        _weibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _weibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _weibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [_weibo handleOpenURL:url];
}

@end

//
//  LeafSettingsViewController.m
//  Leaf
//
//  Created by roger on 13-5-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "SDImageCache.h"
#import "RFHUD.h"

#import "LeafSettingsViewController.h"
#import "LeafNavigationBar.h"
#import "LeafSettingCell.h"
#import "LeafConfig.h"
#import "LeafWebViewController.h"

#define kLeafSettingCellMarginLeft 0.0f
#define kLeafSettingCellSize CGSizeMake(320.0f, 49.0f)

@interface LeafSettingsViewController ()
{
    UILabel *_diskCacheSizeLabel;
    LeafSettingCell *_clean;
    UILabel *_login;
}

@property (nonatomic, assign) UILabel *diskCacheSizeLabel;

- (int)cacheSize;
- (void)clearDisk;

@end

@implementation LeafSettingsViewController
@synthesize diskCacheSizeLabel = _diskCacheSizeLabel;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _login = nil;
    _diskCacheSizeLabel = nil;
    _clean = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark - Handle Cell Events

- (void)menuItemClicked:(id)sender
{
    DDMenuController *menuController = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
}

- (void)accountSettingsClicked
{
    SinaWeibo *weibo = [self sinaweibo];
    if (weibo.isAuthValid) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"退出后将无法使用分享功能"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"仍要退出"
                                                   otherButtonTitles:nil];
        [action showInView:_container];
        [action release];
    }
    else
    {
        [weibo logIn];
    }
}

- (void)switchValueChanged:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    BOOL isOn = sw.isOn;
    LeafConfig *config = [LeafConfig sharedInstance];
    config.simple = isOn;

}

- (void)cleanClicked
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"离线的文章也将被清除哦，确定要清除缓存吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}


- (void)aboutClicked
{
    
}

- (void)opensourceClicked
{
    NSString *pagePath = [[NSBundle mainBundle] pathForResource:@"open_source" ofType:@"html"];
    NSString *page = [NSString stringWithContentsOfFile:pagePath encoding:NSUTF8StringEncoding error:nil];
    __block LeafWebViewController *controller = [[LeafWebViewController alloc] init];
    controller.view.frame = _container.frame;
    [self presentViewController:controller option:LeafAnimationOptionVertical completion:^{
        [controller loadContent:page];
        [controller enablePanRightGestureWithDismissBlock:NULL];
        [controller release], controller = nil;
    }];
}

#pragma disk cache utils

- (int)cacheSize
{
    int size = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path= [paths objectAtIndex:0];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
        
    }
    
    NSString *tmp = NSTemporaryDirectory();
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:tmp error:nil];
    size += [attrs fileSize];
    
    return size/1024.0f/1024.0f; // MB
}

- (void)clearDisk
{
    NSLog(@"begin clean");
    [[SDImageCache sharedImageCache] clearDisk];
    
    NSString *tmp = NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tmp error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:tmp
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    NSLog(@"clean complete");
}

- (void)refreshCacheSizeLabel:(NSString *)text
{
    if (_diskCacheSizeLabel) {
        CGSize size = [text sizeWithFont:kLeafFont15 constrainedToSize:kLeafSettingCellSize];
        _diskCacheSizeLabel.text = text;
        CGRect frame = CGRectMake(kLeafSettingCellSize.width - size.width - 24.0f, (kLeafSettingCellSize.height - size.height)/2.0f , size.width, size.height);
        _diskCacheSizeLabel.frame = frame;
    }

}

- (void)getCacheSize
{
    NSString *text;
    int size = [self cacheSize];
    if (size <= 0) {
        text = @"0MB";
    }
    else
    {
        text = [NSString stringWithFormat:@"%dMB", size];
    }
    [self refreshCacheSizeLabel:text];
    [_clean setUserInteractionEnabled:YES];
}

- (void)weiboDidLogin
{
    _login.text = @"已登录";
}

- (void)weiboDidLogout
{
    _login.text = @"未登陆";
}

#pragma mark -
#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar setTitle:@"设置"];
    [bar addLeftItemWithStyle:LeafNavigationItemStyleMenu target:self action:@selector(menuItemClicked:)];
    //_bar = bar;
    [_container addSubview:bar];
    [bar release];
    
    UILabel *login = [[UILabel alloc] initWithText:@"已登录" font:kLeafFont15 textColor:[UIColor blackColor] andOrigin:CGPointZero];
    login.userInteractionEnabled = NO;
    _login = login;
    SinaWeibo *weibo = [self sinaweibo];
    if (!weibo.isAuthValid) {
        _login.text = @"未登陆";
    }
    
    CGFloat offsetY = 64.0f;
    LeafSettingCell *accountSettings = [[LeafSettingCell alloc] init];
    [accountSettings addTarget:self action:@selector(accountSettingsClicked)];
    accountSettings.hasArrow = YES;
    [accountSettings setTitle:@"新浪微博"];
    [accountSettings setImage:[UIImage imageNamed:@"weibo_more"]];
    [accountSettings setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [_container addSubview:accountSettings];
    offsetY = CGRectGetMaxY(accountSettings.frame) + 20.0f;
    
    _login.frame = CGRectMake(CGRectGetWidth(accountSettings.frame) - CGRectGetWidth(_login.frame) - 50.0f, (CGRectGetHeight(accountSettings.frame) - CGRectGetHeight(_login.frame))/2.0f, CGRectGetWidth(_login.frame), CGRectGetHeight(_login.frame));
    [accountSettings addSubview:_login];
    [login release];
    [accountSettings release];
    
    
    LeafSettingCell *blank = [[LeafSettingCell alloc] init];
    blank.simple = YES;
    [blank setTitle:@"无图模式"];
    [blank setImage:[UIImage imageNamed:@"image_load_more"]];
    [blank setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [_container addSubview:blank];
    
    UISwitch *sw = [[UISwitch alloc] init];
    [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [sw setFrame:CGRectMake(223.0f, 11.0f, 79.0f, 27.0f)];
    [sw setUserInteractionEnabled:YES];
    [blank addSubview:sw];
    LeafConfig *config = [LeafConfig sharedInstance];
    if (config.simple) {
        [sw setOn:YES];
    }
    else {
        [sw setOn:NO];
    }
    [sw release];
    
    offsetY = CGRectGetMaxY(blank.frame) - 1.0f;
    [blank release];
    
    LeafSettingCell *clean = [[LeafSettingCell alloc] init];
    [clean addTarget:self action:@selector(cleanClicked)];
    [clean setTitle:@"清除缓存"];
    [clean setImage:[UIImage imageNamed:@"clean_more"]];
    [clean setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [_container addSubview:clean];
    _clean = clean;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = kLeafFont15;
    
    CGRect frame = label.frame;
    frame.origin.x = CGRectGetWidth(clean.frame) - CGRectGetWidth(frame) - 24.0f;
    frame.origin.y = (CGRectGetHeight(clean.frame) - CGRectGetHeight(frame))/2.0f;
    label.frame = frame;
    _diskCacheSizeLabel = label;
    [clean addSubview:label];
    [label release];
    [clean release];
    [_clean setUserInteractionEnabled:NO];
    
    [self performSelectorInBackground:@selector(getCacheSize) withObject:nil];
    
    offsetY = CGRectGetMaxY(_clean.frame) + 20.0f;
    
    LeafSettingCell *about = [[LeafSettingCell alloc] init];
    [about addTarget:self action:@selector(aboutClicked)];
    about.hasArrow = YES;
    [about setTitle:@"关于"];
    [about setImage:[UIImage imageNamed:@"about_more"]];
    [about setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [_container addSubview:about];
    offsetY = CGRectGetMaxY(about.frame) - 1.0f;
    [about release];

    LeafSettingCell *opensource = [[LeafSettingCell alloc] init];
    [opensource addTarget:self action:@selector(opensourceClicked)];
    opensource.hasArrow = YES;
    [opensource setTitle:@"开源声明"];
    [opensource setImage:[UIImage imageNamed:@"feedback_more"]];
    [opensource setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [_container addSubview:opensource];
    offsetY = CGRectGetMaxY(opensource.frame) + 20.0f;
    [opensource release];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(weiboDidLogin) name:kSinaWeiboDidLogin object:nil];
    [defaultCenter addObserver:self selector:@selector(weiboDidLogout) name:kSinaWeiboDidLogout object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark - UIAlertViewDelegate Method

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // confirm, clean disk cache
        __block LeafSettingsViewController *controller = self;
        RFHUD *hud = [[RFHUD alloc] initWithFrame:kLeafWindowRect];
        [hud setHudFont:kLeafFont15];
        [hud setHUDType:RFHUDTypeWaiting andStatus:@"正在清理缓存"];
        hud.dismissBlock = ^(void){
            controller.diskCacheSizeLabel.text = @"0MB";
        };
        [hud show];
        [hud dismissAfterDelay:3.0f];
        [hud release];
        [self performSelectorInBackground:@selector(clearDisk) withObject:nil];
    }
}


#pragma mark -
#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // logout
        SinaWeibo *weibo = [self sinaweibo];
        [weibo logOut];
    }
}


@end

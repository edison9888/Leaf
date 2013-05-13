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

#define kLeafSettingCellMarginLeft 0.0f
#define kLeafSettingCellSize CGSizeMake(320.0f, 49.0f)

@interface LeafSettingsViewController ()
{
    UILabel *_diskCacheSizeLabel;
    LeafSettingCell *_clean;
}

@property (nonatomic, assign) UILabel *diskCacheSizeLabel;

- (int)cacheSize;
- (void)clearDisk;

@end

@implementation LeafSettingsViewController
@synthesize diskCacheSizeLabel = _diskCacheSizeLabel;


- (void)dealloc
{
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
    
    CGFloat offsetY = 64.0f;
    LeafSettingCell *accountSettings = [[LeafSettingCell alloc] init];
    [accountSettings addTarget:self action:@selector(accountSettingsClicked)];
    accountSettings.hasArrow = YES;
    [accountSettings setTitle:@"账号设置"];
    [accountSettings setImage:[UIImage imageNamed:@"weibo_more"]];
    [accountSettings setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [self.view addSubview:accountSettings];
    offsetY = CGRectGetMaxY(accountSettings.frame) + 20.0f;
    [accountSettings release];
    
    
    LeafSettingCell *blank = [[LeafSettingCell alloc] init];
    blank.simple = YES;
    [blank setTitle:@"2G/3G为无图模式"];
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
        [hud setHUDType:RFHUDTypeWaiting andStatus:@"正在清理缓冲"];
        hud.dismissBlock = ^(void){
            controller.diskCacheSizeLabel.text = @"0MB";
        };
        [hud show];
        [hud dismissAfterDelay:3.0f];
        [hud release];
        [self performSelectorInBackground:@selector(clearDisk) withObject:nil];
    }
}
@end

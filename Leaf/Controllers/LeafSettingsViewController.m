//
//  LeafSettingsViewController.m
//  Leaf
//
//  Created by roger on 13-5-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafSettingsViewController.h"
#import "LeafNavigationBar.h"
#import "LeafSettingCell.h"
#import "LeafConfig.h"

#define kLeafSettingCellMarginLeft 0.0f

@interface LeafSettingsViewController ()

@end

@implementation LeafSettingsViewController


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
    [clean setTitle:@"清理缓冲"];
    [clean setImage:[UIImage imageNamed:@"clean_more"]];
    [clean setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [_container addSubview:clean];
    [clean release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
    [accountSettings setTitle:@"账号设置"];
    [accountSettings setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [self.view addSubview:accountSettings];
    offsetY = CGRectGetMaxY(accountSettings.frame) + 20.0f;
    [accountSettings release];
    
    
    LeafSettingCell *blank = [[LeafSettingCell alloc] init];
    blank.simple = YES;
    [blank setTitle:@"2G/3G为无图模式"];
    [blank setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [blank setUserInteractionEnabled:YES];
    [_container addSubview:blank];
    offsetY =  CGRectGetMinY(blank.frame) + 11.0f;
    [blank release];

    UISwitch *sw = [[UISwitch alloc] init];
    [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [sw setFrame:CGRectMake(223.0f, offsetY, 79.0f, 27.0f)];
    [sw setUserInteractionEnabled:YES];
    [_container addSubview:sw];
    LeafConfig *config = [LeafConfig sharedInstance];
    if (config.simple) {
        [sw setOn:YES];
    }
    else {
        [sw setOn:NO];
    }

    [sw release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

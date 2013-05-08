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

#define kLeafSettingCellMarginLeft 0.0f

@interface LeafSettingsViewController ()

@end

@implementation LeafSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar setTitle:@"设置"];
    [bar addLeftItemWithStyle:LeafNavigationItemStyleMenu target:self action:@selector(menuItemClicked:)];
    //_bar = bar;
    [_container addSubview:bar];
    [bar release];
    
    CGFloat offsetY = 54.0f;
    LeafSettingCell *accountSettings = [[LeafSettingCell alloc] initWithTitle:@"账号设置"];
    accountSettings.hasArrow = YES;
    [accountSettings setOrigin:CGPointMake(kLeafSettingCellMarginLeft, offsetY)];
    [self.view addSubview:accountSettings];
    [accountSettings release];
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  LeafMenuController.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMenuController.h"
#import "LeafHelper.h"
#import "LeafConfig.h"
#import "LeafMenuItem.h"

#define kLeafMenuItemSize CGSizeMake(240.0f, 60.0f)
#define kLeafMenuItemBeginY 20.0f

#define kLeafMenuItemNewslistColor [UIColor colorWithRed:CGColorConvert(220.0f) green:CGColorConvert(169.0f) blue:CGColorConvert(119.0f) alpha:1.0f] 
#define kLeafMenuItemDownloadedListColor [UIColor colorWithRed:CGColorConvert(100.0f) green:CGColorConvert(222.0f) blue:CGColorConvert(100.0f) alpha:1.0f]

#define kLeafMenuMidGreen  [UIColor colorWithRed:CGColorConvert(89.0) green:CGColorConvert(132.0) blue:CGColorConvert(122.0f) alpha:1.0f]
#define kLeafMenuMidDarkGreen  [UIColor colorWithRed:CGColorConvert(62.0f) green:CGColorConvert(89.0f) blue:CGColorConvert(83.0f) alpha:1.0f]

#define kLeafMenuBlue [UIColor colorWithRed:CGColorConvert(0.0f) green:CGColorConvert(174.0f) blue:CGColorConvert(192.0) alpha:1.0f]
#define kLeafMenuDarkBlue [UIColor colorWithRed:CGColorConvert(0.0f) green:CGColorConvert(115.0) blue:CGColorConvert(126.0) alpha:1.0f]

#define kLeafMenuGreen [UIColor colorWithRed:CGColorConvert(111.0f) green:CGColorConvert(202.0f) blue:CGColorConvert(43.0f) alpha:1.0f]
#define kLeafMenuDarkGreen [UIColor colorWithRed:CGColorConvert(74.0f) green:CGColorConvert(135.0f) blue:CGColorConvert(38.0f) alpha:1.0f]

@implementation LeafMenuController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)imageModeChanged:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    LeafConfig *config = [LeafConfig sharedInstance];
    if (sw.on) {
        config.simple = YES;
    }
    else
    {
        config.simple = NO;
    }
}

- (void)menuItemClicked:(id)sender
{
    
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kLeafBackgroundColor;
    
    CGFloat offsetY = kLeafMenuItemBeginY;    
    NSArray *titleArray = [NSArray arrayWithObjects:@"最近新闻", @"已下载", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"menu_latest", @"menu_saved", nil];
    NSArray *colorArray = [NSArray arrayWithObjects:kLeafMenuMidGreen, kLeafMenuBlue, nil];
    NSArray *hlArray = [NSArray arrayWithObjects:kLeafMenuMidDarkGreen, kLeafMenuDarkBlue, nil];
    
    for (int i = 0; i < titleArray.count; i++) {
        LeafMenuItem *item = [[LeafMenuItem alloc] initWithFrame:CGRectMake(0.0f, offsetY, kLeafMenuItemSize.width, kLeafMenuItemSize.height)];
        item.tag = i;
        [item setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
        [item setTitle:[titleArray objectAtIndex:i]];
        [item setColor:[colorArray objectAtIndex:i] highlight:[hlArray objectAtIndex:i]];
        [item addTarget:self action:@selector(menuItemClicked:)];
        
        offsetY += CGHeight(item.frame) + 30.0f;
        [self.view addSubview:item];
        [item release];
    }
    
   /* UIView *imageModeConfigPanel = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 200.0f, 40.0f)];
    [imageModeConfigPanel setBackgroundColor:[UIColor yellowColor]];
    UILabel *imageModeLabel = [[UILabel alloc] initWithText:@"无图模式" font:kLeafFont15 textColor:[UIColor blackColor] andOrigin:CGPointMake(0.0f, 0.0f)]; 
    imageModeLabel.center = CGPointMake(imageModeLabel.center.x, CGHeight(imageModeConfigPanel.frame)/2.0f);
    
    [imageModeConfigPanel addSubview:imageModeLabel];
    [imageModeLabel release];
    
    UISwitch *sw = [[UISwitch alloc] init];
    [sw setFrame:CGRectMake(CGWidth(imageModeLabel.frame) + 30.0f,  0.0f, CGWidth(sw.frame), CGHeight(sw.frame))];
    [sw addTarget:self action:@selector(imageModeChanged:) forControlEvents:UIControlEventValueChanged];
    sw.center = CGPointMake(sw.center.x, CGHeight(imageModeConfigPanel.frame)/2.0f);
    LeafConfig *config = [LeafConfig sharedInstance];
    if (config.simple) {
        [sw setOn:YES];
    }
    else {
        [sw setOn:NO];
    }
    [imageModeConfigPanel addSubview:sw];
    [sw release];
    [self.view addSubview:imageModeConfigPanel];
    [imageModeConfigPanel release];*/
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

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

#import "DDMenuController.h"
#import "LeafMainViewController.h"
#import "LeafOfflineViewController.h"

#define kLeafMenuItemSize CGSizeMake(240.0f, 60.0f)
#define kLeafMenuItemBeginY 20.0f

#define kLeafMenuMidGreen  [UIColor colorWithRed:CGColorConvert(89.0f) green:CGColorConvert(132.0f) blue:CGColorConvert(122.0f) alpha:1.0f]
#define kLeafMenuMidDarkGreen  [UIColor colorWithRed:CGColorConvert(62.0f) green:CGColorConvert(89.0f) blue:CGColorConvert(83.0f) alpha:1.0f]

#define kLeafMenuBlue [UIColor colorWithRed:CGColorConvert(0.0f) green:CGColorConvert(174.0f) blue:CGColorConvert(192.0f) alpha:1.0f]
#define kLeafMenuDarkBlue [UIColor colorWithRed:CGColorConvert(0.0f) green:CGColorConvert(115.0f) blue:CGColorConvert(126.0f) alpha:1.0f]

#define kLeafMenuPurple [UIColor colorWithRed:CGColorConvert(81.0f) green:CGColorConvert(56.0f) blue:CGColorConvert(88.0f) alpha:1.0f]
#define kLeafMenuDarkPurple [UIColor colorWithRed:CGColorConvert(52.0f) green:CGColorConvert(36.0f) blue:CGColorConvert(55.0f) alpha:1.0f]


#define kLeafMenuGreen [UIColor colorWithRed:CGColorConvert(111.0f) green:CGColorConvert(202.0f) blue:CGColorConvert(43.0f) alpha:1.0f]
#define kLeafMenuDarkGreen [UIColor colorWithRed:CGColorConvert(74.0f) green:CGColorConvert(135.0f) blue:CGColorConvert(38.0f) alpha:1.0f]


@interface LeafMenuController ()
{
    @private
    DDMenuController *_menuController;
    LeafMainViewController *_mainController;
}
@end

@implementation LeafMenuController


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
    UIButton *menuItem = (UIButton *)sender;
    switch (menuItem.superview.tag) {
        case LeafMenuItemTypeLatestNews:
            [_menuController setRootController:_mainController animated:YES];
            break;
        case LeafMenuItemTypeSaved:
        {
            LeafOfflineViewController *controller = [[LeafOfflineViewController alloc] init];
            controller.downloadAtOnce = NO;
            [_menuController setRootController:controller animated:YES];
            [controller release];
            
        }

            break;
        case LeafMenuItemTypeDownloadNow:
            {
                LeafOfflineViewController *controller = [[LeafOfflineViewController alloc] init];
                controller.downloadAtOnce = YES;
                [_menuController setRootController:controller animated:YES];
                [controller release];
                
            }
            break;
        default:
            break;
    }
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kLeafBackgroundColor;
    
    CGFloat offsetY = kLeafMenuItemBeginY;    
    NSArray *titleArray = [NSArray arrayWithObjects:@"最近新闻", @"已离线", @"马上离线", @"设置", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"menu_latest", @"menu_saved", @"menu_download", @"menu_setting", nil];
    NSArray *colorArray = [NSArray arrayWithObjects:kLeafMenuMidGreen, kLeafMenuBlue, kLeafMenuPurple, kLeafMenuGreen, nil];
    NSArray *hlArray = [NSArray arrayWithObjects:kLeafMenuMidDarkGreen, kLeafMenuDarkBlue, kLeafMenuDarkPurple, kLeafMenuDarkGreen, nil];
    
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
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _menuController = delegate.menuController;
    _mainController = delegate.mainController;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

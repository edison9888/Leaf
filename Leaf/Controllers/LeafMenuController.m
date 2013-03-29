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

#define kLeafMenuItemSize CGSizeMake(270.0f, 40.0f)
#define kLeafMenuItemPaddingLeft 14.0f
#define kLeafMenuItemBeginY 48.0f

#define kLeafMenuItemNewslistColor [UIColor colorWithRed:CGColorConvert(220.0f) green:CGColorConvert(169.0f) blue:CGColorConvert(119.0f) alpha:1.0f] 
#define kLeafMenuItemDownloadedListColor [UIColor colorWithRed:CGColorConvert(100.0f) green:CGColorConvert(222.0f) blue:CGColorConvert(100.0f) alpha:1.0f]

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

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:CGColorConvert(35.0f) green:CGColorConvert(38.0f) blue:CGColorConvert(43.0f) alpha:0.9];
    
    CGFloat offsetY = kLeafMenuItemBeginY;    
    NSArray *titleArray = [NSArray arrayWithObjects:@"新闻列表", @"已离线", nil];
    NSArray *logoArray = [NSArray arrayWithObjects:@"newslist", @"downloaded", nil];
    NSArray *highlightArray = [NSArray arrayWithObjects:kLeafMenuItemNewslistColor, kLeafMenuItemDownloadedListColor, nil];
    
    for (int i = 0; i < titleArray.count; i++) {
        LeafMenuItem *item = [[LeafMenuItem alloc] initWithFrame:CGRectMake(kLeafMenuItemPaddingLeft, offsetY, kLeafMenuItemSize.width, kLeafMenuItemSize.height)];
        [item setImage:[UIImage imageNamed:[logoArray objectAtIndex:i]]];
        [item setTitle:[titleArray objectAtIndex:i] highlight:[highlightArray objectAtIndex:i]];
        [self.view addSubview:item];    
        offsetY = CGOriginY(item.frame) + CGHeight(item.frame);
        [item release];
        
        UIImage *line = [UIImage imageNamed:@"divider_line"];
        UIImageView *divider = [[UIImageView alloc] initWithFrame:CGRectMake(kLeafMenuItemPaddingLeft, offsetY, line.size.width, line.size.height)];
        [divider setImage:line];
        offsetY += line.size.height;
        [self.view addSubview:divider];
        [divider release];
        
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

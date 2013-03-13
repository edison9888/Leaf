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
    
    NSLogRect(self.view.frame);
    
    UIView *imageModeConfigPanel = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 200.0f, 40.0f)];
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
    if (!config.simple) {
        [sw setOn:NO];
    }
    else {
        [sw setOn:YES];
    }
    [imageModeConfigPanel addSubview:sw];
    [sw release];
    [self.view addSubview:imageModeConfigPanel];
    [imageModeConfigPanel release];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

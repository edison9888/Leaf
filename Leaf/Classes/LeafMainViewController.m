//
//  LeafMainViewController.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMainViewController.h"
#import "LeafNavigationBar.h"
#import "UIViewController+NSSidebarController.h"


@implementation LeafMainViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)homeItemClicked:(id)sender
{
    NSLog(@"back home.");
    [self.sidebarController showLeftController];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.view = view;
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar addItemWithStyle:LeafNavigationItemStyleHome target:self action:@selector(homeItemClicked:)];
    [self.view addSubview:bar];
    [bar release];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

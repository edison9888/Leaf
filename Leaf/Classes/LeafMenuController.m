//
//  LeafMenuController.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMenuController.h"
#import "LeafHelper.h"

@implementation LeafMenuController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLogRect(self.view.frame);
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"你好"];
    [label setFrame:CGRectMake(10.0f, 10.0f, 50.0f, 30.0f)];
    [self.view addSubview:label];
    [label release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

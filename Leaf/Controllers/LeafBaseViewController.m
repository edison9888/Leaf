//
//  LeafBaseViewController.m
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafBaseViewController.h"
#import "LeafHelper.h"

@interface LeafBaseViewController ()

@end

@implementation LeafBaseViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:container];
    _container = container;
    [container release];
    
    UIView *mask = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mask];
    mask.hidden = YES;
    _mask = mask;
    [mask release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark - ViewController Presentation

- (void)presentViewController:(UIViewController *)controller option:(LeafAnimationOption)option
{
    if (!controller) {
        NSLog(@"controller is nil.");
        return;
    }
    if (option == LeafAnimationOptionHorizontal) {
        CGRect frame = controller.view.frame;
        frame.origin.x = CGWidth(self.view.bounds);
        controller.view.frame = frame;
        [self.view addSubview:controller.view];
    }
}

- (void)dismissViewControllerWithOption:(LeafAnimationOption)option
{
    
}

@end

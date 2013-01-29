//
//  LeafContentViewController.m
//  Leaf
//
//  Created by roger on 13-1-29.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafContentViewController.h"

@implementation LeafContentViewController

- (void)dealloc
{
    [_url release], _url = nil;
    [super dealloc];
}

- (id)initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        _url = [url retain];
    }
    
    return self;
}


#pragma mark -
#pragma mark - ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

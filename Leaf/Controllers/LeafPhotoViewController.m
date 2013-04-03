//
//  LeafPhotoViewController.m
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafPhotoViewController.h"
#import "LeafPhotoView.h"
#import "LeafBottomBar.h"
#import "LeafHelper.h"

#define kLeafBottomProgressBarH 2.0f

@interface LeafPhotoViewController ()
@property (nonatomic, retain) NSArray *urls;
@end

@implementation LeafPhotoViewController
@synthesize urls = _urls;

- (void)dealloc
{
    [_urls release], _urls = nil;
    
    [super dealloc];
}

- (id)initWithURLs:(NSArray *)urls
{
    self = [super init];
    if (self) {
        self.urls = urls;
    }
    
    return self;
}


#pragma mark - 

- (void)returnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    LeafBottomBar *bottom = [[LeafBottomBar alloc] initWithFrame:CGRectMake(0.0f, CGHeight(self.view.frame) - 40.0f - 1.0f, CGWidth(self.view.frame), 40.0f)];
    [self.view addSubview:bottom];
    [bottom addTarget:self action:@selector(returnClicked:)];
    [bottom release];
    
    LeafPhotoView *photoView = [[LeafPhotoView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, CGWidth(self.view.frame), CGHeight(self.view.frame) - 10.0f - 41.0f)];
    [self.view addSubview:photoView];
    [photoView setURL:[NSURL URLWithString:[_urls objectAtIndex:0]]];
    [photoView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end

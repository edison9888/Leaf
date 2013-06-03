//
//  LeafHtmlController.m
//  Leaf
//
//  Created by roger on 13-6-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafHtmlController.h"
#import "LeafBottomBar.h"

@interface LeafHtmlController ()
{
    UIWebView *_content;
}

@end

@implementation LeafHtmlController


- (void)dealloc
{
    _content = nil;
    
    [super dealloc];
}

#pragma mark -

- (void)backClicked
{
    [self dismissViewControllerWithOption:LeafAnimationOptionHorizontal
                               completion:NULL];
}


#pragma mark - 
#pragma mark - ViewController LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LeafBottomBar *bar = [[LeafBottomBar alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(_container.frame) - 40.0f, CGRectGetWidth(_container.frame), 40.0f)];
    bar.leftItemType = LeafBottomBarItemTypeBack;
    [bar addLeftTarget:self action:@selector(backClicked)];
    [_container addSubview:bar];
    [bar release];
    
    UIWebView *content = [[UIWebView alloc] init];
    _content = content;
    [_content setFrame:CGRectMake(0.0f, 0.0f, 320.0f, CGHeight(self.view.frame) - 40.0f)];
    _content.scalesPageToFit = YES;
    _content.dataDetectorTypes = UIDataDetectorTypeNone;
    [_container addSubview:_content];
    [content release];
}

- (void)loadContent:(NSString *)content
{
    [_content loadHTMLString:content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

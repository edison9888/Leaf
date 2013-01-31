//
//  LeafContentViewController.m
//  Leaf
//
//  Created by roger on 13-1-29.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafContentViewController.h"
#import "LeafNavigationBar.h"
#import "LeafHelper.h"
#import "LeafLoadingView.h"

@implementation LeafContentViewController

- (void)dealloc
{
    [_url release], _url = nil;
    [_connection release], _connection = nil;
    
    _content = nil;
    _loading = nil;
    [super dealloc];
}

- (id)initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        _url = [url retain];
    }
    
    return self;
}

#pragma mark -

- (void)backClicked:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)showLeafLoadingView
{
    if (_loading.hidden) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        CGPoint center = _loading.center;
        center.y -= 30.0f;
        
        [UIView animateWithDuration:0.7f
                              delay:0.25f
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             _loading.center = center;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        

    }
}


- (void)hideLeafLoadingView
{
    if (!_loading.hidden) {
        CGPoint center = _loading.center;
        center.y += 30;
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             _loading.center = center;
                         }
                         completion:^(BOOL finished) {
                             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                             _loading.hidden = YES;
                         }];

    }
}

- (void)GET
{
    if (!_connection) {
        _connection = [[LeafURLConnection alloc] init];
    }
    
    [_connection GET:_url];
    [self showLeafLoadingView];
}

#pragma mark -
#pragma Test UIWebView

- (void)inject:(UIWebView *)webView
{
    NSString *leafJSPath = [[NSBundle mainBundle] pathForResource:@"leaf" ofType:@"js"];
    NSString *leafJS = [NSString stringWithContentsOfFile:leafJSPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *jQueryPath = [[NSBundle mainBundle] pathForResource:@"jquery-1.7.2" ofType:@"js"];
    NSString *jQuery = [NSString stringWithContentsOfFile:jQueryPath encoding:NSUTF8StringEncoding error:nil];
    
    [webView stringByEvaluatingJavaScriptFromString:leafJS];
    [webView stringByEvaluatingJavaScriptFromString:jQuery];
    
}

- (void)loadLocalPage
{
    NSString *pagePath = [[NSBundle mainBundle] pathForResource:@"page" ofType:@"html"];
    NSString *page = [NSString stringWithContentsOfFile:pagePath encoding:NSUTF8StringEncoding error:nil];
    [_content loadHTMLString:page baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
    
}

#pragma mark -
#pragma mark - ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"url: %@", [_url description]);
    
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar addLeftItemWithStyle:LeafNavigationItemStyleBack target:self action:@selector(backClicked:)];
    [self.view addSubview:bar];
    [bar release];
    
    UIWebView *content = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, CGWidth(self.view.frame), CGHeight(self.view.frame) - 44.0f)];
    content.backgroundColor = [UIColor clearColor];
    content.delegate = self;
    _content = content;
    [self.view addSubview:content];
    [content release];
    
    LeafLoadingView *loading = [[LeafLoadingView alloc] initWithFrame:CGRectMake(0.0f, CGHeight(self.view.frame), CGWidth(self.view.frame), 30.0f)];
    _loading = loading;
    _loading.hidden = YES;
    [self.view addSubview:_loading];
    [loading release];
    
    _connection = nil;
    
    //[self showLeafLoadingView];
    //[self performSelector:@selector(hideLeafLoadingView) withObject:nil afterDelay:3.0f];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}



#pragma mark - 
#pragma LeafUrlConnectionDelegate Methods

- (void)didFinishLoadingData:(NSMutableData *)data
{
    NSString *page = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"page content: %@", page);
    [page release];
}

- (void)didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    [self hideLeafLoadingView];
}


@end

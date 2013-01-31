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

- (void)backClicked:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (NSString *)replaceFontFamily:(NSString *)pagecontent
{
    
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
    
    NSString *pagePath = [[NSBundle mainBundle] pathForResource:@"page" ofType:@"html"];
    NSString *page = [NSString stringWithContentsOfFile:pagePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *leafJSPath = [[NSBundle mainBundle] pathForResource:@"leaf" ofType:@"js"];
    NSString *leafJS = [NSString stringWithContentsOfFile:leafJSPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *jQueryPath = [[NSBundle mainBundle] pathForResource:@"jquery-1.7.2" ofType:@"js"];
    NSString *jQuery = [NSString stringWithContentsOfFile:jQueryPath encoding:NSUTF8StringEncoding error:nil];
    
    UIWebView *content = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, CGWidth(self.view.frame), CGHeight(self.view.frame) - 44.0f)];
    content.backgroundColor = [UIColor clearColor];
    content.delegate = self;
    content.opaque = NO;
    content.backgroundColor = kLeafBackgroundColor;
    
    [content stringByEvaluatingJavaScriptFromString:jQuery];
    [content stringByEvaluatingJavaScriptFromString:leafJS];
        
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [content loadRequest:request];
    
    
    
     //[content loadHTMLString:page baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
   
    [self.view addSubview:content];
    [content release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finished load");
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.fontFamily =\"FZLanTingHei-R-GBK\""];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').style.fontFamily =\"FZLanTingHei-R-GBK\""];
}

@end

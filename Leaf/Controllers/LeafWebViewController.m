//
//  LeafWebViewController
//  Leaf
//
//  Created by roger qian on 12-12-3.
//  Copyright (c) 2012年 Mobimtech. All rights reserved.
//

#import "LeafWebViewController.h"

#define kOpenInSafari 0
#define kCopyLink 1

@implementation LeafWebViewController
@synthesize url = _url;

- (void)dealloc
{
    _mainWebView.delegate = nil;
    [_url release], _url = nil;
    [_mainWebView release], _mainWebView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)updateToolBar
{
    _goBackBtn.enabled = [_mainWebView canGoBack];
    _goForwardBtn.enabled = [_mainWebView canGoForward];
}

#pragma mark - ToolBar Events

- (void)goBackClick
{
    [_mainWebView goBack];
}

- (void)goForwardClick
{
    [_mainWebView goForward];
}

- (void)moreClick
{
    UIActionSheet *pageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"在Safari中打开", @"复制链接", nil];
    
    [pageSheet showInView:self.view];
    [pageSheet release];    
}

- (void)closeClick
{
    [_mainWebView stopLoading];
    [self dismissViewControllerWithOption:LeafAnimationOptionVertical
                               completion:NULL];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // goBack button
    _goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goBackBtn setImage:[UIImage imageNamed:@"LeafWebViewController.bundle/browser_toolbar_return"] forState:UIControlStateNormal];
    [_goBackBtn addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
    [_goBackBtn setFrame:CGRectMake(10.0f, 6.0f, 32.0f, 32.0f)];
    [_goBackBtn setContentEdgeInsets:UIEdgeInsetsMake(-4.0f, -4.0f, -4.0f, -4.0f)];
    [_goBackBtn setEnabled:NO];
    
    // goForward button
    _goForwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goForwardBtn setImage:[UIImage imageNamed:@"LeafWebViewController.bundle/browser_toolbar_next"] forState:UIControlStateNormal];
    [_goForwardBtn addTarget:self action:@selector(goForwardClick) forControlEvents:UIControlEventTouchUpInside];
    [_goForwardBtn setFrame:CGRectMake(56.0f, 6.0f, 32.0f, 32.0f)];
    [_goForwardBtn setContentEdgeInsets:UIEdgeInsetsMake(-4.0f, -4.0f, -4.0f, -4.0f)];
    [_goForwardBtn setEnabled:NO];
    
    // more button
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"LeafWebViewController.bundle/browser_toolbar_more"] forState:UIControlStateNormal];
    [moreBtn setFrame:CGRectMake(236.0f, 6.0f, 32.0f, 32.0f)];
    [moreBtn setContentEdgeInsets:UIEdgeInsetsMake(-4.0f, -4.0f, -4.0f, -4.0f)];
    [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(278.0f, 6.0f, 32.0f, 32.0f)];
    [closeBtn setImage:[UIImage imageNamed:@"LeafWebViewController.bundle/browser_toolbar_setno"] forState:UIControlStateNormal];
    [closeBtn setContentEdgeInsets:UIEdgeInsetsMake(-4.0f, -4.0f, -4.0f, -4.0f)];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    // toolBar
    UIImageView *toolBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeafWebViewController.bundle/browser_toolbar_bg"]];
    [toolBar setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    [toolBar setUserInteractionEnabled:YES];
    
    [toolBar addSubview:_goBackBtn];
    [toolBar addSubview:_goForwardBtn];
    [toolBar addSubview:moreBtn];
    [toolBar addSubview:closeBtn];
    [self.view addSubview:toolBar];
    [toolBar release];
    
    _mainWebView = [[UIWebView alloc] init];
    [_mainWebView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, CGHeight(self.view.frame) - 44.0f)];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:_url]];
    _mainWebView.scalesPageToFit = YES;
    _mainWebView.delegate = self;
    [self.view addSubview:_mainWebView];
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


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index: %d", buttonIndex);
    if (kOpenInSafari == buttonIndex) 
    {
        [[UIApplication sharedApplication] openURL:self.url];
    }
    else if(kCopyLink == buttonIndex)
    {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = self.url.absoluteString;
    }
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.url = webView.request.URL;
    [self updateToolBar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolBar];
}


@end

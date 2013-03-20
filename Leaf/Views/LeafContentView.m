//
//  LeafContentView.m
//  Leaf
//
//  Created by roger qian on 13-3-20.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafContentView.h"
#import "TFHpple.h"
#import "LeafNavigationBar.h"
#import "LeafHelper.h"
#import "LeafLoadingView.h"
#import "LeafConfig.h"

@implementation LeafContentView
@synthesize videoUrl = _videoUrl;
@synthesize url = _url;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
        [bar addLeftItemWithStyle:LeafNavigationItemStyleBack target:self action:@selector(backClicked:)];
        [bar addRightItemWithStyle:LeafNavigationItemStyleSafari target:self action:@selector(safariClicked:)];
        [self addSubview:bar];
        [bar release];
        
        UIWebView *content = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, CGWidth(self.frame), CGHeight(self.frame) - 44.0f)];
        content.backgroundColor = [UIColor clearColor];
        content.delegate = self;
        content.scrollView.bounces = NO;
        _content = content;
        [self addSubview:content];
        [content release];
        
        LeafLoadingView *loading = [[LeafLoadingView alloc] initWithFrame:CGRectMake(0.0f, CGHeight(self.frame), CGWidth(self.frame), 30.0f)];
        _loading = loading;
        [self addSubview:_loading];
        [loading release];
        
        _connection = nil;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        [pan release];

    }
    return self;
}


- (void)dealloc
{
    [_url release], _url = nil;
    [_videoUrl release], _videoUrl = nil;
    [_connection release], _connection = nil;
    
    _content = nil;
    _loading = nil;
    [super dealloc];
}

#pragma mark -

- (void)showLeftView
{
    __block CGPoint center = self.center;

    [UIView animateWithDuration:0.3f 
                          delay:0.0f 
                        options:UIViewAnimationCurveEaseInOut 
                     animations:^{
                         center.x = CGWidth(self.superview.frame) + CGWidth(self.frame)/2.0f;
                         self.center = center;
                     } 
                     completion:^(BOOL finished) {
                         [_content stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML = ''"];
                         [_connection cancel];
                         _connection.delegate = nil;
                     }];
}

- (void)backClicked:(id)sender
{
    [self showLeftView];
}

- (void)safariClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
}


- (void)showLeafLoadingView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    CGPoint center = _loading.center;
    center.y = (CGHeight(self.frame) - CGHeight(_loading.frame)/2.0f);
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         _loading.center = center;
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}


- (void)hideLeafLoadingView
{
    CGPoint center = _loading.center;
    center.y = CGHeight(self.frame) + CGHeight(_loading.frame)/2.0f;
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         _loading.center = center;
                     }
                     completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     }];
    
}

- (void)GET
{
    [self showLeafLoadingView];
    if (!_connection) {
        _connection = [[LeafURLConnection alloc] init];
        _connection.delegate = self;
    }
    
    [_connection GET:_url];
    
}

#pragma mark -
#pragma UIWebView Stuff

- (void)loadURL:(NSString *)url
{
    NSLog(@"loadURL: %@", url);
    _connection.delegate = self;
    self.url = url;
    [self GET];
}

- (NSString *)injectLeafCSS:(NSString *)original
{
    NSMutableString *html = nil;
    if (!original) {
        NSLog(@"original is nil");
        return nil;
    }
    
    NSRange rangeStyle = [original rangeOfString:@"<style>"];    
    if (rangeStyle.length <= 0) {
        NSLog(@"original does not contain <style>");
        return nil;
    }
    
    NSUInteger location = rangeStyle.location + rangeStyle.length;
    
    if (original.length > location) {
        NSString *subHead = [original substringToIndex:location];
        NSString *subTail = [original substringFromIndex:location];
        html = [[NSMutableString alloc] init];
        [html safeAppendString:subHead];
        NSString *leafCSSPath = [[NSBundle mainBundle] pathForResource:@"leaf" ofType:@"css"];
        NSString *leafCSS = [NSString stringWithContentsOfFile:leafCSSPath encoding:NSUTF8StringEncoding error:nil];        
        [html safeAppendString:leafCSS];
        [html safeAppendString:subTail];
        return [html autorelease];
    }
    NSLog(@"something wrong with the original html.");
    return nil;
}

- (void)validateVideoUrl:(NSString *)url
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSString *sub = nil;
    
    if ([[url lowercaseString] hasPrefix:@"http://"]) {
        sub = [url substringFromIndex:7];
        [result safeAppendString:@"http://"];
    }
    else if([[url lowercaseString] hasPrefix:@"https://"]){
        sub = [url substringFromIndex:8];
        [result safeAppendString:@"https://"];
    }
    else
    {
        sub = url;
        [result safeAppendString:@"http://"];
    }
    
    [result safeAppendString:[sub stringByReplacingOccurrencesOfString:@"//" withString:@"/"]];
    NSLog(@"result: %@", result);
    self.videoUrl = result;
    [result release];
}

- (NSString *)purgeImageLinks:(NSString *)html
{
    NSRange r;
    NSString *result = [[html copy] autorelease];
    while ((r = [result rangeOfString:@"<img[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        result = [result stringByReplacingCharactersInRange:r withString:@""];
    }
    return result;
}

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
#pragma mark - handle pan gesture

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {        
        
        _panOriginX = self.frame.origin.x;        
        _panVelocity = CGPointMake(0.0f, 0.0f);
        
        if([gesture velocityInView:self.superview].x > 0) {
            _panDirection = LeafPanDirectionRight;
        } else {
            _panDirection = LeafPanDirectionLeft;
        }
        
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [gesture velocityInView:self.superview];
        if((velocity.x*_panVelocity.x + velocity.y*_panVelocity.y) < 0) {
            _panDirection = (_panDirection == LeafPanDirectionRight) ? LeafPanDirectionLeft : LeafPanDirectionRight;
        }
        
        _panVelocity = velocity;        
        CGPoint translation = [gesture translationInView:self.superview];
        CGRect frame = self.frame;
        frame.origin.x = _panOriginX + translation.x;
        
        if(frame.origin.x > 0)
        {
            if (_state == LeafPanStateNone) {
                _state = LeafPanStateShowingLeft;
            }
            if (_state == LeafPanStateShowingLeft) {
                self.frame = frame;
            }
        }
    } 
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        LeafPanCompletion  completion =  LeafPanCompletionNone;
        
        if (_state == LeafPanStateShowingLeft && _panDirection == LeafPanDirectionRight) {
            completion = LeafPanCompletionLeft;
        }
        else if(_state == LeafPanStateShowingLeft && _panDirection == LeafPanDirectionLeft)
        {
            completion = LeafPanCompletionNone;
        }
       
        if (completion == LeafPanCompletionLeft) {
            [self showLeftView];
        }
        else if(completion == LeafPanDirectionNone){
            __block CGPoint center = self.center;
            [UIView animateWithDuration:0.3f 
                                  delay:0.0f 
                                options:UIViewAnimationCurveEaseIn 
                             animations:^{
                                 center.x = CGWidth(self.superview.frame)/2.0f;
                                 self.center = center;
                             } 
                             completion:^(BOOL finished) {
                
                             }];
        }
    }
}

#pragma UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"UIWebViewNavigationTypeLinkClicked");
    }
    
    NSLog(@"url: %@", [[request URL] absoluteString]);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLeafLoadingView];
    if (_videoUrl) {
        [_content stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('video')[0].src = '%@'", _videoUrl]];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLeafLoadingView];
}



#pragma mark - 
#pragma LeafUrlConnectionDelegate Methods

- (void)didFinishLoadingData:(NSMutableData *)data
{
    NSString *page = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];    
    NSString *html = [self injectLeafCSS:page];
    [page release];
    
    // xpath
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray * elements = [doc searchWithXPathQuery:@"//img"];
    
    //TFHppleElement *element = [elements objectAtIndex:0];
    for (TFHppleElement *element in elements) {
        NSLog(@"img[@src]: %@", [element objectForKey:@"src"]);
    }
    
    NSArray *videoUrls = [doc searchWithXPathQuery:@"//video"];
    if (videoUrls && videoUrls.count > 0) {
        for (TFHppleElement *videoUrl in videoUrls) {
            NSString *url = [videoUrl objectForKey:@"src"];
            [self validateVideoUrl:url];
        }
    }
    
    LeafConfig *config = [LeafConfig sharedInstance];
    if (config.simple) {
        html = [self purgeImageLinks:html];
    }    
    //NSLog(@"html: %@", html);
    [_content loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
}

- (void)didFailWithError:(NSError *)error
{
    [self hideLeafLoadingView];
}

- (void)connectionDidCancel
{
    [self hideLeafLoadingView];
}




@end

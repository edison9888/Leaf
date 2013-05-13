//
//  LeafContentViewController.m
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "ASIDownloadCache.h"
#import "RFHUD.h"

#import "LeafContentViewController.h"
#import "LeafNavigationBar.h"
#import "LeafHelper.h"
#import "LeafLoadingView.h"
#import "TFHpple.h"
#import "LeafConfig.h"
#import "LeafPhotoViewController.h"
#import "LeafWebViewController.h"
#import "LeafCommentViewController.h"
#import "LeafComposeViewController.h"
#import "GCDHelper.h"

#define kLeafContentCSS @"body { \
background:#ECEAE2 !important; \
    font-weight:normal !important; \
    word-wrap:break-word !important; \
} \
span { \
    font-family:FZLanTingHei-R-GBK !important; \
    font-size:12pt !important; \
    font-weight: normal !important; \
} \
h2 { \
    font-family:FZLanTingHei-R-GBK !important; \
    font-weight: normal !important; \
    font-size:15pt !important; \
    text-align:left !important; \
} \
b { \
    font-family:FZLanTingHei-R-GBK !important; \
    font-weight: normal !important; \
} \
strong { \
    font-family:FZLanTingHei-R-GBK !important; \
    font-weight: normal !important; \
} \
a { \
    color:#4a8711 !important; \
} \
video { \
    max-width:285px !important; \
    height:auto !important; \
} \
iframe { \
    max-width:285px !important; \
    height:auto !important; \
}" 


@interface LeafContentViewController ()
{
    RFHUD *_hud;
}

@property (nonatomic, retain) NSMutableArray *urls;

- (void)cancelAll;

- (void)handleData:(NSData *)data;

- (NSString *)fileNameForKey:(NSString *)key;

@end

@implementation LeafContentViewController
@synthesize videoUrl = _videoUrl;
@synthesize url = _url;
@synthesize urls = _urls;
@synthesize articleId = _articleId;
@synthesize articleTitle = _articleTitle;


- (void)dealloc
{
    [_articleId release], _articleId = nil;
    [_articleTitle release], _articleTitle = nil;
    [_url release], _url = nil;
    [_videoUrl release], _videoUrl = nil;
    [_urls release], _urls = nil;
    [_videoUrl release], _videoUrl = nil;
    [_connection release], _connection = nil;
    _content = nil;
    _loading = nil;
    [super dealloc];
}

- (id)initWithURL:(NSString *)url andTitle:(NSString *)title
{
    
    if (self = [super init]) {
        self.url = url;
        self.articleTitle = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar addLeftItemWithStyle:LeafNavigationItemStyleBack target:self action:@selector(backClicked:)];
    [bar addRightItemWithStyle:LeafNavigationItemStyleShare target:self action:@selector(shareClicked:)];
    [_container addSubview:bar];
    [bar release];
        
    UIWebView *content = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, CGWidth(self.view.frame), CGHeight(self.view.frame) - 44.0f)];
    content.backgroundColor = [UIColor clearColor];
    content.opaque = NO;
    content.delegate = self;
    content.scrollView.bounces = NO;
    content.dataDetectorTypes = UIDataDetectorTypeNone;
    _content = content;
    [_container addSubview:content];
    [content release];
    _connection = nil;
    
    LeafLoadingView *loading = [[LeafLoadingView alloc] initWithFrame:CGRectMake(0.0f, CGHeight(self.view.frame), CGWidth(self.view.frame), 30.0f)];
    _loading = loading;
    [_container addSubview:_loading];
    [loading release];
    _loading.hidden = YES;
    
    __block LeafContentViewController *contentViewController = self;
    [self enablePanRightGestureWithDismissBlock:^{
        [contentViewController blockDDMenuControllerGesture:NO];
        [contentViewController cancelAll];
    }];
    
    [self enablePanLeftGestureWithWillCoverBlock:^{
        LeafCommentViewController *vc = [[LeafCommentViewController alloc] init];
        CGRect frame = contentViewController.view.frame;
        vc.view.frame = CGRectMake(CGWidth(frame), 0.0f, CGWidth(frame), CGHeight(frame));
        [contentViewController pushController:vc];
        vc.hasMask = YES;
        [vc loadData:contentViewController.articleId];
        [vc release];
    } coveredBlock:NULL
    andDismissBlock:^{
        LeafCommentViewController *controller = (LeafCommentViewController *)contentViewController.childController;
        [controller cancel];
    }];
    
    _urls = [[NSMutableArray alloc] init];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - Utils

- (void)cancelAll
{
    [_connection cancel];
    _connection.delegate = nil;
    [_content stopLoading];
    _content.delegate = nil;
}

- (void)presentComposeController:(UIImage *)image
{
    NSString *status = [NSString stringWithFormat:@" //%@ -- (来自 Leaf)", _articleTitle];
    LeafComposeViewController *vc = [[LeafComposeViewController alloc] init];
    vc.view.frame = self.view.bounds;
    [vc setStatus:status];
    [vc setImage:image];
    [self presentViewController:vc option:LeafAnimationOptionVertical completion:^{
        self.shouldBlockGesture = YES;
    }];
    [vc release];

}

- (UIImage *)convertWebViewToImage
{
    CGPoint currentOffset = _content.scrollView.contentOffset;
    
    CGFloat totalHeight = _content.scrollView.contentSize.height;
    CGFloat offsetY = 0.0f;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    while (offsetY < (totalHeight - 10.0f)) {
        @autoreleasepool {
            UIGraphicsBeginImageContext(_content.frame.size);
            
            [_content.scrollView setContentOffset:CGPointMake(0.0f, offsetY)];
            [_content.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [images addObject:image];
            offsetY += image.size.height;

        }
    }
    
    UIGraphicsBeginImageContext(_content.scrollView.contentSize);
    offsetY = 0.0f;
    
    for (UIImage *image in  images) {
        [image drawAtPoint:CGPointMake(0.0f, offsetY)];
        offsetY += image.size.height;
    }
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images release];
    
    [_content.scrollView setContentOffset:currentOffset];
    return fullImage;
}




- (BOOL)isSupportedExtension:(NSString *)extension
{
    if (!extension) {
        return NO;
    }
    NSSet *extensions = [NSSet setWithObjects:@"png", @"jpg", @"jpeg", @"bmp", @"tif", @"tiff", nil];
    return [extensions containsObject:extension];
}


- (NSString *)fileNameForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    NSString *extension = [key pathExtension];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return  [filename stringByAppendingPathExtension:extension];
}

- (NSString *)cachePathForKey:(NSString *)key
{
     NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    const char *str = [key UTF8String];
    NSString *extension = [key pathExtension];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [[documentPath stringByAppendingPathComponent:filename] stringByAppendingPathExtension:extension];
}

- (void)saveFile:(NSData *)data atPath:(NSString *)path
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    [manager createFileAtPath:path contents:data attributes:NULL];
    [manager release];
}

#pragma mark -
#pragma mark - Handle Events

- (void)backClicked:(id)sender
{
    [self dismissViewControllerWithOption:LeafAnimationOptionHorizontal
                               completion:^(void){
                                   [self cancelAll];
                                   [self blockDDMenuControllerGesture:NO];
                               }];
}

- (void)shareClicked:(id)sender
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    if ([sinaweibo isAuthValid]) {
        __block UIImage *image = [[self convertWebViewToImage] retain];
        RFHUD *hud = [[RFHUD alloc] initWithFrame:kLeafWindowRect];
        _hud = hud;
        [hud setHudFont:kLeafFont15];
        [hud setHUDType:RFHUDTypeWaiting andStatus:@"正在生成长微博"];
        [hud show];
        [hud release];
        
        __block UIImage *newImage;
        __block LeafContentViewController *controller = self;
        [GCDHelper dispatchBlock:^{
                            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                            newImage = [[UIImage alloc] initWithData:imageData];
                            [image release];
                        }
                        complete:^{
                            _hud.dismissBlock = ^(void){
                                [controller presentComposeController:newImage];
                                [newImage release];
                            };
                            [_hud dismissAfterDelay:1.5f];
                        }];
    }
    else{
        [sinaweibo logIn];
    }
    
    
}

- (void)safariClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
}



#pragma mark -
#pragma mark - Loading Content

- (void)showLeafLoadingView:(BOOL)showIndicator
{
    if (showIndicator) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    _loading.hidden = NO;
    CGPoint center = _loading.center;
    center.y = (CGHeight(self.view.frame) - CGHeight(_loading.frame)/2.0f);
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _loading.center = center;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}


- (void)hideLeafLoadingView
{
    CGPoint center = _loading.center;
    center.y = CGHeight(self.view.frame) + CGHeight(_loading.frame)/2.0f;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _loading.center = center;
                     }
                     completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                         _loading.hidden = YES;
                     }];
    
}

- (void)GET
{
    NSLog(@"article url: %@", _url);
    NSString *path = [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[NSURL URLWithString:_url]];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            [self showLeafLoadingView:NO];
            [self handleData:data];
            return;
        }
    }
    [self showLeafLoadingView:YES];
    if (!_connection) {
        _connection = [[LeafURLConnection alloc] init];
        _connection.delegate = self;
    }
    NSLog(@"article url: %@", _url);
    [_connection GET:_url];
    
}


#pragma mark - 
#pragma mark - HTML Stuff

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
        [html safeAppendString:kLeafContentCSS];
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

#pragma UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"UIWebViewNavigationTypeLinkClicked");
        NSString *url = [[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *doc = [[request mainDocumentURL] absoluteString];
        NSString *extension = [[url pathExtension] lowercaseString];
        NSLog(@"url: %@,\n doc: %@\n extension: %@", url, doc, extension);
        if ([self isSupportedExtension:extension]) {
            int index = [_urls indexOfObject:url];
            
            if (index == NSNotFound) {
                NSString *cachedPath = [self fileNameForKey:url];
                index = [_urls indexOfObject:cachedPath];
            }
            
            index = index != NSNotFound? index:0;
            LeafPhotoViewController *vc = [[LeafPhotoViewController alloc] initWithURLs:_urls];
            [vc setCurIndex:index];
            vc.view.frame = self.view.bounds;
            [self presentViewController:vc
                                 option:LeafAnimationOptionVertical
                             completion:^(void){
                                 self.shouldBlockGesture = YES;
                             }];
            [vc release];
        }
        else {
            LeafWebViewController *vc = [[LeafWebViewController alloc] initWithUrl:request.URL];
            [self presentViewController:vc option:LeafAnimationOptionVertical
                             completion:^(void){
                                 self.shouldBlockGesture = YES;
                             }];
            [vc release];
        }
        return NO;
    }
    
    NSLog(@"url: %@", [[request URL] absoluteString]);
    return YES;
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


- (void)handleData:(NSData *)data
{
    NSString *page = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *html = [self injectLeafCSS:page];
    [page release];
    
    // xpath
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [doc searchWithXPathQuery:@"//img"];
    
    [_urls removeAllObjects];
    //TFHppleElement *element = [elements objectAtIndex:0];
    for (TFHppleElement *element in elements) {
        NSString *link = [element objectForKey:@"src"];
        NSString *ext = [[link lowercaseString] pathExtension];
        if ([self isSupportedExtension:ext]) {
            NSString *url = [link stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [_urls addObject:url];
        }
        NSLog(@"img src: %@", link);
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
    
    [_content loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[ASIDownloadCache sharedCache] pathForSessionDurationCacheStoragePolicy] isDirectory:YES]];
    [doc release];
}


#pragma mark -
#pragma LeafUrlConnectionDelegate Methods

- (void)didFinishLoadingData:(NSMutableData *)data
{
    [self handleData:data];
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

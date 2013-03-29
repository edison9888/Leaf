//
//  LeafDownloadTask.m
//  Leaf
//
//  Created by roger qian on 13-3-27.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafDownloadTask.h"
#import "LeafHelper.h"
#import "TFHpple.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"

#define kNewsListURL @"http://www.cnbeta.com/api/getNewsList.php?limit=50"
#define kArticleUrl  @"http://www.cnbeta.com/api/getNewsContent2.php?articleId=%@"

@implementation LeafDownloadTask
@synthesize url = _url;
@synthesize request = _request;
- (void)dealloc
{
    [_url release], _url = nil;
    [_request setDelegate:nil];
	[_request setDownloadProgressDelegate:nil];
	[_request cancel];
    [_request release], _request = nil;
    [super dealloc];
}

- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        self.url = url;
        _executing = NO;
        _finished = NO;
    }
    
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)start
{
    if ([self isCancelled]) {
    // Must move the operation to the finished state if it is canceled. 
        [self willChangeValueForKey:@"isFinished"]; 
        _finished = YES; 
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"]; 
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _executing = YES; 
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main
{    
    [self willChangeValueForKey:@"isFinished"];
    _finished = NO;
    [self didChangeValueForKey:@"isFinished"];
    
    if (_url) {
        NSData *htmlData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:_url] returningResponse:nil error:nil];
        
        if (htmlData) {
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
            NSArray *elements = [doc searchWithXPathQuery:@"//img"];
            [doc release];
            for (TFHppleElement *element in elements) {                
                NSString *imageUrl = [element objectForKey:@"src"];
                [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] returningResponse:nil error:nil];
                //NSLog(@"downloaded image: %@", imageUrl);
            }            
        }        
    } 
    
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
     
}


- (void)fetchURL
{
	[_request setDelegate:nil];
	[_request cancel];
	[self setRequest:[ASIWebPageRequest requestWithURL:_url]];
    
	[_request setDidFailSelector:@selector(webPageFetchFailed:)];
	[_request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
	[_request setDelegate:self];
	[_request setDownloadProgressDelegate:self];
	[_request setUrlReplacementMode:ASIReplaceExternalResourcesWithLocalURLs];
	
	// It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
	[_request setDownloadCache:[ASIDownloadCache sharedCache]];
	[_request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
	[_request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:_request]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
	[_request startAsynchronous];
}

- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
	
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
	NSURL *baseURL;
	// If we're using ASIReplaceExternalResourcesWithLocalURLs, we must set the baseURL to point to our locally cached file
    baseURL = [NSURL fileURLWithPath:[_request downloadDestinationPath]];
	    
	if ([theRequest downloadDestinationPath]) {
		NSString *response = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
        NSLog(@"response %@", response);
    } 
}

// At time of writing ASIWebPageRequests do not support automatic progress tracking across all requests needed for a page
// The code below shows one approach you could use for tracking progress - it creates a new row with a progress indicator for each resource request
// However, you could use the same approach and keep track of an overal total to show progress
/*
- (void)requestStarted:(ASIWebPageRequest *)theRequest
{
	
}

- (void)requestFinished:(ASIWebPageRequest *)theRequest
{
	if ([theRequest downloadDestinationPath]) {
		NSString *response = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
        NSLog(@"response: %@", response);
    } 
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}
*/

@end

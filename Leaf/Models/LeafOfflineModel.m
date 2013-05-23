//
//  LeafOfflineModel.m
//  Leaf
//
//  Created by roger on 13-4-24.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafOfflineModel.h"

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"
#import "LeafNewsData.h"

#define kLeafOfflineTotal   50
#define kDownloadNewsListURL @"http://www.cnbeta.com/api/getNewsList.php?limit=%d"
#define kArticleUrl  @"http://www.cnbeta.com/api/getNewsContent2.php?articleId=%@"


@interface LeafOfflineModel ()
{
    NSInteger _count;
}
@end

@implementation LeafOfflineModel
@synthesize progress = _progress;
@synthesize array = _array;

- (void)dealloc
{
    [_array release], _array = nil;
    [super dealloc];
}


- (id)init
{
    if (self = [super init]) {
        _array = [[NSMutableArray alloc] init];
        _progress = 0.0f;
    }
    
    return self;
}

- (void)cancel
{
    for (ASIHTTPRequest *request in ASIHTTPRequest.sharedQueue.operations){
        [request clearDelegatesAndCancel];
    }
}

#pragma mark - JSON Serialization

- (void)JSONforData:(NSData *)data
{
    if (!data) {
        NSLog(@"data is nil.");
        return;
    }
    
    [_array removeAllObjects];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (array) {
        for (int i = 0; i<array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            
            if (dict) {
                LeafNewsData *leaf = [[LeafNewsData alloc] init];
                leaf.theme = [dict stringForKey:@"theme"];
                leaf.pubTime = [dict stringForKey:@"pubtime"];
                leaf.title = [dict stringForKey:@"title"];
                leaf.cmtNum = [dict stringForKey:@"cmtnum"];
                leaf.articleId = [dict stringForKey:@"ArticleID"];
                [_array addObject:leaf];
                [leaf release];
            }
        }
    }

    
}

#pragma mark -
#pragma mark - Download The Latest 50 News

- (void)fetchURL:(NSURL *)url
{
    ASIWebPageRequest *request = [ASIWebPageRequest requestWithURL:url];
    
	[request setDidFailSelector:@selector(webPageFetchFailed:)];
	[request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
	[request setDelegate:self];
	
	[request setUrlReplacementMode:ASIReplaceExternalResourcesWithLocalURLs];
	
	// It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
	[request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
    [request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
	[request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
	[request setShouldIgnoreExternalResourceErrors:YES];
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    [request startAsynchronous];
}

- (void)downloadNewsInfo:(NSNumber *)flag
{
    BOOL clearFirst = [flag boolValue];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    NSString *url = [NSString stringWithFormat:kDownloadNewsListURL, kLeafOfflineTotal];

    if (clearFirst) {
        NSString *path = [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[NSURL URLWithString:url]];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    else{
        NSString *path = [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[NSURL URLWithString:url]];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            [self JSONforData:data];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineState object:self];
        return;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDidFailSelector:@selector(newsInfoFetchFailed:)];
	[request setDidFinishSelector:@selector(newsInfoFetchSucceeded:)];
    [request setDelegate:self];
	
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    

	
    [request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
	[request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    [request startAsynchronous];
}


- (void)downloadNews:(BOOL)clearFirst
{
    _count = 0;
    [self performSelectorInBackground:@selector(downloadNewsInfo:) withObject:[NSNumber numberWithBool:clearFirst]];
}

#pragma mark - 
#pragma mark - ASIHTTPRequest Delegate Methods

- (void)newsInfoFetchSucceeded:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if (!error && [request downloadDestinationPath]) {
        NSData *data = [NSData dataWithContentsOfFile:[request downloadDestinationPath]];
        if (!data) {
            NSLog(@"data is nil");
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineFailed object:self];
            return;
        }
        
        NSString *log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"offline-data: %@", log);
        [log release];
        
        [self JSONforData:data];
        
        if (_array) {
            for (LeafNewsData *leaf in _array) {
                NSString *articleId = leaf.articleId;
                if (articleId && ![articleId isEqualToString:@""]) {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kArticleUrl, articleId]];
                    [self fetchURL:url];
                }
            }
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineFailed object:self];
    }

}


- (void)newsInfoFetchFailed:(ASIHTTPRequest *)theRequest
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineFailed object:self];
}


- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
    _count++;
    _progress = (float)_count/(float)kLeafOfflineTotal;

	[[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineUpdateProgress object:self];
    if (_count >= kLeafOfflineTotal) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineFinished object:self];
    }
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
    _count++;
    _progress = (float)_count/(float)kLeafOfflineTotal;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineUpdateProgress object:self];
    if (_count >= kLeafOfflineTotal) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineFinished object:self];
    }
}


@end

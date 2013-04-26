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

#pragma mark -
#pragma mark - Download The Latest 50 News

- (void)fetchURL:(NSURL *)url
{
    ASIWebPageRequest *request = [ASIWebPageRequest requestWithURL:url];
    
	[request setDidFailSelector:@selector(webPageFetchFailed:)];
	[request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUrlReplacementMode:ASIReplaceExternalResourcesWithLocalURLs];
	
	// It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
	[request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
    [request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
	[request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    [request startAsynchronous];
}

- (void)downloadNewsInfo:(BOOL)clearFirst
{
    
    NSString *url = [NSString stringWithFormat:kDownloadNewsListURL, kLeafOfflineTotal];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    if (clearFirst) {
        NSString *path = [request downloadDestinationPath];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
    [request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
	[request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error && [request downloadDestinationPath]) {
        NSData *data = [NSData dataWithContentsOfFile:[request downloadDestinationPath]];
        if (!data) {
            NSLog(@"data is nil");
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineFailed object:self];
            return;
        }
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (array) {
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dict = [array objectAtIndex:i];
                
                if (dict) {
                    NSString *articleId = [dict stringForKey:@"ArticleID"];
                    if (articleId && ![articleId isEqualToString:@""]) {
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kArticleUrl, articleId]];
                        [self fetchURL:url];
                    }
                }
            }
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineFailed object:self];
    }
}

- (void)downloadNews:(BOOL)clearFirst
{
    _count = 0;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(downloadNewsInfo:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(downloadNewsInfo:)];
    [invocation setArgument:&clearFirst atIndex:2];
    [invocation performSelectorInBackground:@selector(invoke) withObject:nil];
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
    /*
	NSURL *baseURL;
	// If we're using ASIReplaceExternalResourcesWithLocalURLs, we must set the baseURL to point to our locally cached file
    baseURL = [NSURL fileURLWithPath:[theRequest downloadDestinationPath]];
    
	if ([theRequest downloadDestinationPath]) {
		NSString *response = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
    }*/
    _count++;
    _progress = (float)_count/(float)kLeafOfflineTotal;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineUpdateProgress object:self];
    if (_count >= kLeafOfflineTotal) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafOfflineFinished object:self];
    }
}


@end

//
//  LeafCommentModel.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "LeafCommentModel.h"

#define kLeafCommentURL @"http://www.cnbeta.com/api/getComment.php?article="
#define kLeafSupportURL @"http://www.cnbeta.com/Ajax.vote.php?tid=%@&support=1"
#define kLeafAgainstURL @"http://www.cnbeta.com/Ajax.vote.php?tid=%@&against=1"

@implementation LeafCommentData
@synthesize name = _name;
@synthesize time = _time;
@synthesize comment = _comment;
@synthesize tid = _tid;
@synthesize support = _support;
@synthesize against = _against;

- (void)dealloc
{
    [_name release], _name = nil;
    [_time release], _time = nil;
    [_comment release], _comment = nil;
    [_tid release], _tid = nil;
    [_comment release], _comment = nil;
    [_against release], _against = nil;
    
    [super dealloc];
}

@end



@implementation LeafCommentModel
@synthesize dataArray = _dataArray;
@synthesize articleId = _articleId;

- (void)dealloc
{
    _connection.delegate = nil;
    [_connection release], _connection = nil;
    [_dataArray release], _dataArray = nil;
    [_articleId release], _articleId = nil;
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        _connection = [[LeafURLConnection alloc] init];
        _connection.delegate = self;
        _dataArray = [[NSMutableArray alloc] init];
    }
    return  self;
}

- (void)load:(NSString *)articleId
{
    if (!articleId) {
        NSLog(@"invalid article id!");
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentFailed object:self];
        return;
    }
    self.articleId = articleId;
    NSString *url = [kLeafCommentURL stringByAppendingString:articleId];
    if (_connection) {
        [_connection GET:url];
    }
}

- (void)cancel
{
    if (_connection) {
        [_connection cancel];
        _connection.delegate = nil;
    }
}


- (void)support:(NSString *)tid
{
  /* NSURL *url = [NSURL URLWithString:@"http://www.cnbeta.com/comment.htm"];
    NSLog(@"url: %@", url.absoluteString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
    [properties setValue:@"f3600451275bb83727b58657a702fb7e8e8ab588" forKey:NSHTTPCookieValue];
    [properties setValue:@"YII_CSRF_TOKEN" forKey:NSHTTPCookieName];
    [properties setValue:@"www.cnbeta.com" forKey:NSHTTPCookieDomain];
    //[properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookie];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    NSMutableArray *cookies = [NSMutableArray arrayWithObjects:cookie, nil];
    [request setRequestMethod:@"PUT"];
    [request appendPostData:[[@"op=support&YII_CSRF_TOKEN=f3600451275bb83727b58657a702fb7e8e8ab588&sid=242247&tid=7618624" urlEncode] dataUsingEncoding:NSUTF8StringEncoding]];
    request.delegate = self;
    [request setRequestCookies:cookies];
    [request setUseCookiePersistence:NO];
    [request setDidFinishSelector:@selector(requestDidFinish:)];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    */
    NSDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
    [properties setValue:@"f3600451275bb83727b58657a702fb7e8e8ab588" forKey:NSHTTPCookieValue];
    [properties setValue:@"YII_CSRF_TOKEN" forKey:NSHTTPCookieName];
    [properties setValue:@"www.cnbeta.com" forKey:NSHTTPCookieDomain];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    
    NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    NSMutableArray *cookies = [NSMutableArray arrayWithObjects:cookie, nil];
    
    
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.cnbeta.com/comment.htm"]];
    [request setRequestCookies:cookies];
    [request setUseCookiePersistence:NO];
    request.delegate = self;
    request.didFinishSelector = @selector(requestDidFinish:);
    request.didFailSelector = @selector(requestDidFailed:);
    [request setPostValue:@"support" forKey:@"op"];
    [request setPostValue:_articleId forKey:@"sid"];
    [request setPostValue:tid forKey:@"tid"];
    [request setPostValue:@"f3600451275bb83727b58657a702fb7e8e8ab588" forKey:@"YII_CSRF_TOKEN"];
    
    [request startAsynchronous];

}

- (void)against:(NSString *)tid
{
    NSURL *url = [NSURL URLWithString:@"http://www.cnbeta.com/comment.htm"];
    //NSLog(@"url: %@", url.absoluteString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    //request.delegate = self;
    //[request setDidFinishSelector:@selector(requestDidFinish:)];
    //[request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];

}

#pragma mark - ASIHTTPRequest Delegate

- (void)requestDidFinish:(ASIHTTPRequest *)request
{
    NSString *response = request.responseString;
    NSLog(@"response: %@", response);
    NSLog(@"status code: %d", request.responseStatusCode);
}

- (void)requestDidFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request failed.");
    NSLog(@"header: %@", [[request responseHeaders] description]);
}


#pragma mark - LeafURLConnectionDelegate Methods

- (void)didFinishLoadingData:(NSMutableData *)data
{
    if (!data) {
        NSLog(@"LeafCommentData: data is nil.");
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentEmpty object:self];
        return;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    [_dataArray removeAllObjects];
    if (array && array.count > 0) {
        for (NSDictionary *dict in array) {
            if (![dict isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentEmpty object:self];
                return;
            }
            LeafCommentData *data = [[LeafCommentData alloc] init];
            data.name = [dict stringForKey:@"name"];
            data.comment = [dict stringForKey:@"comment"];
            data.time = [dict stringForKey:@"date"]; // TODO: friendly date formate
            data.tid = [dict stringForKey:@"tid"];
            data.support = [dict stringForKey:@"support"];
            data.against = [dict stringForKey:@"against"];
            [_dataArray addObject:data];
            [data release];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentSuccess object:self];
    }
    else {
       [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentEmpty object:self];
    }
}

- (void)didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentFailed object:self];
}

- (void)connectionDidCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentCanceled object:self];
}

@end

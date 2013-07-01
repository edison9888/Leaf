//
//  LeafCommentModel.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "LeafCookieManager.h"
#import "LeafCommentData.h"
#import "LeafCommentModel.h"

 // @"http://www.cnbeta.com/api/getComment.php?article=" // old api deprecated

#define kLeafCommentURL @"http://www.cnbeta.com/comment.htm?op=info&page=1&sid="
#define kLeafSupportURL @"http://www.cnbeta.com/Ajax.vote.php?tid=%@&support=1"
#define kLeafAgainstURL @"http://www.cnbeta.com/Ajax.vote.php?tid=%@&against=1"
#define kLeafVoteURL @"http://www.cnbeta.com/comment.htm"


@interface LeafCommentModel ()
{
    ASIHTTPRequest *_request;
}

@property (nonatomic, retain) ASIHTTPRequest *request;

@end


@implementation LeafCommentModel
@synthesize dataArray = _dataArray;
@synthesize articleId = _articleId;
@synthesize request = _request;

- (void)dealloc
{
    [_dataArray release], _dataArray = nil;
    [_articleId release], _articleId = nil;
    if (_request) {
        [_request clearDelegatesAndCancel];
        [_request release], _request = nil;
    }
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
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

    if (_request) {
        [_request clearDelegatesAndCancel];
    }
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    _request.delegate = self;
    _request.didFinishSelector = @selector(commentDidFinish:);
    _request.didFailSelector = @selector(commentDidFailed:);
    [_request startAsynchronous];
}

- (void)cancel
{
    if (_request) {
        [_request clearDelegatesAndCancel];
    }
}


- (void)vote:(NSString *)op tid:(NSString *)tid
{
    LeafCookieManager *manager = [LeafCookieManager sharedInstance];
    
    NSHTTPCookie *cookie = [manager cookie];
    if (!cookie) {
        return;
    }
    
    NSString *token = [manager token];
    NSMutableArray *cookies = [NSMutableArray arrayWithObjects:cookie, nil];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kLeafVoteURL]];
    [request setRequestCookies:cookies];
    [request setUseCookiePersistence:NO];
    request.delegate = self;
    request.didFinishSelector = @selector(requestDidFinish:);
    request.didFailSelector = @selector(requestDidFailed:);
    [request setPostValue:op forKey:@"op"];
    [request setPostValue:_articleId forKey:@"sid"];
    [request setPostValue:tid forKey:@"tid"];
    [request setPostValue:token forKey:@"YII_CSRF_TOKEN"];
    
    [request startAsynchronous];
}

- (void)support:(NSString *)tid
{
    [self vote:@"support" tid:tid];
}

- (void)against:(NSString *)tid
{
    [self vote:@"against" tid:tid];
}


- (LeafCommentData *)dataForDict:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    LeafCommentData *data = [[LeafCommentData alloc] init];
    data.name = [dict stringForKey:@"name"];
    data.comment = [dict stringForKey:@"comment"];
    data.time = [dict stringForKey:@"date"]; // TODO: friendly date formate
    data.tid = [dict stringForKey:@"tid"];
    int score = [dict intForKey:@"score"];
    int reason = [dict intForKey:@"reason"];
    data.support = [NSString stringWithFormat:@"%d", score];
    data.against = [NSString stringWithFormat:@"%d", reason];

    return [data autorelease];
}

#pragma mark - ASIHTTPRequest Delegate

- (void)commentDidFinish:(ASIHTTPRequest *)request
{
    if (!request.responseData) {
        NSLog(@"comment response data is nil.");
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentFailed object:self];
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL];
    LeafCookieManager *manager = [LeafCookieManager sharedInstance];
    if (dict) {
        if(![manager cookie]) {
            NSString *token = [dict stringForKey:@"token"];
            if (token && ![token isEqualToString:@""]) {
                [manager updateCookie:token];
            }
        }
        
        NSDictionary *result = [dict objectForKey:@"result"];
        
        if (result) {
            
            NSDictionary *cmntStore = [result objectForKey:@"cmntstore"];
            if (cmntStore) {
                NSArray *keys = [cmntStore allKeys];
                
                for (NSString *key  in keys) {
                    NSDictionary *comment = [cmntStore objectForKey:key];
                    if (comment) {
                        LeafCommentData *data = [self dataForDict:comment];
                        NSString *pid = [comment stringForKey:@"pid"];
                        if (pid && ![pid isEqualToString:@""]) {
                            NSDictionary *parent = [cmntStore objectForKey:pid];
                            data.parent = [self dataForDict:parent];
                        }
                        [_dataArray addObject:data];
                    }
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentSuccess object:self];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentEmpty object:self];
    }
    
    
}

- (void)commentDidFailed:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentFailed object:self];
}

#pragma mark - ASIFormDataRequest Delegate

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

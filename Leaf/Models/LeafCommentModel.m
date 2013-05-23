//
//  LeafCommentModel.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import "ASIHTTPRequest.h"

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
@synthesize referer = _referer;

- (void)dealloc
{
    _connection.delegate = nil;
    [_connection release], _connection = nil;
    [_dataArray release], _dataArray = nil;
    [_referer release], _referer = nil;
    
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
    self.referer = [NSString stringWithFormat:kCBArticle, articleId];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kLeafSupportURL, tid]];
    NSLog(@"url: %@", url.absoluteString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Referer" value:_referer];
    //request.delegate = self;
    //[request setDidFinishSelector:@selector(requestDidFinish:)];
    //[request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
}

- (void)against:(NSString *)tid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kLeafAgainstURL, tid]];
    NSLog(@"url: %@", url.absoluteString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Referer" value:_referer];
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

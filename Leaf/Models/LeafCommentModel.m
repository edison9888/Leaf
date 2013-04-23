//
//  LeafCommentModel.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCommentModel.h"
#define kLeafCommentURL @"http://www.cnbeta.com/api/getComment.php?article="

@implementation LeafCommentData
@synthesize name = _name;
@synthesize time = _time;
@synthesize comment = _comment;

- (void)dealloc
{
    [_name release], _name = nil;
    [_time release], _time = nil;
    [_comment release], _comment = nil;
    
    [super dealloc];
}

@end



@implementation LeafCommentModel
@synthesize dataArray = _dataArray;

- (void)dealloc
{
    _connection.delegate = nil;
    [_connection release], _connection = nil;
    [_dataArray release], _dataArray = nil;
    
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
        return;
    }
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


#pragma mark - LeafURLConnectionDelegate Methods

- (void)didFinishLoadingData:(NSMutableData *)data
{
    if (!data) {
        NSLog(@"LeafCommentData: data is nil.");
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentFailed object:self];
        return;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    [_dataArray removeAllObjects];
    for (NSDictionary *dict in array) {
        LeafCommentData *data = [[LeafCommentData alloc] init];
        data.name = [dict stringForKey:@"name"];
        data.comment = [dict stringForKey:@"comment"];
        data.time = [dict stringForKey:@"date"]; // TODO: friendly date formate
        [_dataArray addObject:data];
        [data release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeafLoadCommentSuccess object:self];
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

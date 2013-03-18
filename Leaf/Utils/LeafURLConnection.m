//
//  LeafURLConnection.m
//  Leaf
//
//  Created by roger qian on 13-1-4.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafURLConnection.h"

@implementation LeafURLConnection
@synthesize connection = _connection;
@synthesize delegate = _delegate;


- (void)dealloc
{
    [_connection release], _connection = nil;
    [_receivedData release], _receivedData = nil;    
    _delegate = nil;
    
    [super dealloc];
}

- (id)init 
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _receivedData = nil;
        _connection = nil;
    }
    
    return self;
}

- (void)cancel
{
    //NSLog(@"cancel connect.");
    if (_connection) {
        [_connection cancel];
        [_connection release], _connection = nil;
    }
    [_receivedData release], _receivedData = nil;
    if ([_delegate respondsToSelector:@selector(connectionDidCancel)]) {
        [_delegate connectionDidCancel];
    }
}

- (void)GET:(NSString *)urlStr
{
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (!_connection) {
        NSLog(@"ERROR: GET connection can't be initialized.");
    }
    [request release];
}

- (void)POST:(NSString *)urlStr data:(NSData *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:data];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (!_connection) {
        NSLog(@"ERROR: POST connection can't be initialized.");
    }
    
    [request release];
}


#pragma mark- 
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(didFailWithError:)]) {
        [_delegate didFailWithError:error];
    }
    
    self.connection = nil;
    [_receivedData release], _receivedData = nil;
}

#pragma mark - 
#pragma mark NSURLConnectionDataDelegate Methods


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!_receivedData) {
        _receivedData = [[NSMutableData alloc] initWithData:data];
    }
    else {
        [_receivedData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"didFinishLoading.");
        
    if ([_delegate respondsToSelector:@selector(didFinishLoadingData:)]) {
        [_delegate didFinishLoadingData:_receivedData];
    }
    
    self.connection = nil;
    [_receivedData release], _receivedData = nil;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSCachedURLResponse *memOnlyCachedResponse =
    [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response
                                             data:cachedResponse.data
                                         userInfo:cachedResponse.userInfo
                                    storagePolicy:NSURLCacheStorageAllowed];
    return [memOnlyCachedResponse autorelease];
}


@end

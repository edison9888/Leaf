//
//  LeafCache.m
//  Leaf
//
//  Created by roger qian on 13-3-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCache.h"
#import "SDURLCache.h"

@implementation LeafCache

static LeafCache *_instance = nil;

+ (LeafCache *)sharedInstance
{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (!_instance) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    
    return nil;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}



#pragma mark - 
#pragma mark - Cache Control Stuff

- (id)init
{
    if (self = [super init]) {
        _cache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                               diskCapacity:1024*1024*5000 // 50MB disk cache
                                                   diskPath:[SDURLCache defaultCachePath]
                                         enableForIOS5AndUp:YES];
        [NSURLCache setSharedURLCache:_cache];
    }
    return self;
}

- (void)removeCacheForURL:(NSURL *)url
{
    [_cache removeCachedResponseForURL:url];
}

@end

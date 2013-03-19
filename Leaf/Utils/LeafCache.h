//
//  LeafCache.h
//  Leaf
//
//  Created by roger qian on 13-3-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDURLCache;
@interface LeafCache : NSObject
{
    SDURLCache *_cache;
}

+(LeafCache *)sharedInstance;
- (void)removeCacheForURL:(NSURL *)url;
@end

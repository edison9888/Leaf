//
//  LeafCookieManager.h
//  Leaf
//
//  Created by roger on 13-6-26.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeafCookieManager : NSObject
{
    NSString *_token;
}

@property (nonatomic, retain) NSString *token;

+ (LeafCookieManager *)sharedInstance;

- (NSHTTPCookie *)cookie;
- (void)updateCookie:(NSString *)token;

@end

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
    NSString *_sessionId;
}

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *sessionId;

+ (LeafCookieManager *)sharedInstance;

- (NSHTTPCookie *)cookieForToken;
- (NSHTTPCookie *)cookieForSession;

- (void)updateToken:(NSString *)token;
- (void)updateSessionId:(NSString *)sessionId;
@end

//
//  LeafCookieManager.m
//  Leaf
//
//  Created by roger on 13-6-26.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import "Singleton.h"
#import "LeafCookieManager.h"
#import "ASIHTTPRequest.h"
#import "GCDHelper.h"

#define kArticleURL @"http://www.cnbeta.com/articles/242636.htm"
#define kYIICSRFTOKEN @"YII_CSRF_TOKEN"

@implementation LeafCookieManager
@synthesize token = _token;
@synthesize sessionId = _sessionId;

SINGLETON_FOR_CLASS(LeafCookieManager);

- (id)init
{
    if (self = [super init]) {
        _token = nil;
    }
    return self;
}

- (NSHTTPCookie *)cookieForToken
{
    if (!_token) {
        return nil;
    }
    
    NSDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
    [properties setValue:_token forKey:NSHTTPCookieValue];
    [properties setValue:@"YII_CSRF_TOKEN" forKey:NSHTTPCookieName];
    [properties setValue:@"www.cnbeta.com" forKey:NSHTTPCookieDomain];
    //[properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookie];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    return cookie;
}

- (NSHTTPCookie *)cookieForSession
{
    if (!_sessionId) {
        return nil;
    }
    
    NSDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
    [properties setValue:_sessionId forKey:NSHTTPCookieValue];
    [properties setValue:@"PHPSESSID" forKey:NSHTTPCookieName];
    [properties setValue:@"www.cnbeta.com" forKey:NSHTTPCookieDomain];
    //[properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookie];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    return cookie;

}

- (void)updateToken:(NSString *)token
{
    self.token = token;
}

- (void)updateSessionId:(NSString *)sessionId
{
    self.sessionId = sessionId;
}

@end

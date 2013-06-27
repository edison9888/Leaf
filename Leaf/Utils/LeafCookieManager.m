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

#define kArticleURL @"http://www.cnbeta.com/articles/242247.htm"
#define kYIICSRFTOKEN @"YII_CSRF_TOKEN"

@implementation LeafCookieManager
@synthesize token = _token;

SINGLETON_FOR_CLASS(LeafCookieManager);

- (id)init
{
    if (self = [super init]) {
        _token = nil;
    }
    return self;
}

- (NSHTTPCookie *)cookie
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


- (void)updateCookie
{
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kArticleURL]];
    [GCDHelper dispatchBlock:^{
        [request startSynchronous];
        NSArray *cookies = request.responseCookies;
        for (NSHTTPCookie *cookie in cookies) {
            if ([cookie.name isEqualToString:kYIICSRFTOKEN]) {
                self.token = cookie.value;
            }
        }

    } complete:^{
        
    }];
}

@end

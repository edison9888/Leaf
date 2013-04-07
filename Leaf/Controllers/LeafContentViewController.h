//
//  LeafContentViewController.h
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafBaseViewController.h"
#import "LeafURLConnection.h"



@class LeafLoadingView;
@interface LeafContentViewController : LeafBaseViewController  <UIWebViewDelegate, LeafURLConnectionDelegate>

{
    @private
    LeafLoadingView *_loading;
    UIWebView *_content;
    NSString *_url;
    LeafURLConnection *_connection;
    NSString *_videoUrl;
    

}

@property (nonatomic, retain) NSString *videoUrl;
@property (nonatomic, retain) NSString *url;

- (id)initWithURL:(NSString *)url;
- (void)GET;
@end

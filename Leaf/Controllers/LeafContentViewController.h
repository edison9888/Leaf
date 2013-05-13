//
//  LeafContentViewController.h
//  Leaf
//
//  Created by roger on 13-4-7.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafBaseViewController.h"
#import "LeafURLConnection.h"



@class LeafLoadingView, LeafNewsData;
@interface LeafContentViewController : LeafBaseViewController  <UIWebViewDelegate, LeafURLConnectionDelegate>

{
    @private
    LeafLoadingView *_loading;
    UIWebView *_content;
    LeafURLConnection *_connection;
    NSString *_videoUrl;
    LeafNewsData *_data;
}

@property (nonatomic, retain) NSString *videoUrl;
@property (nonatomic, retain) LeafNewsData *data;

- (id)initWithLeafData:(LeafNewsData *)data;
- (void)GET;

@end

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
@interface LeafContentViewController : LeafBaseViewController  <UIWebViewDelegate, LeafURLConnectionDelegate, SinaWeiboRequestDelegate>

{
    @private
    LeafLoadingView *_loading;
    UIWebView *_content;
    NSString *_url;
    LeafURLConnection *_connection;
    NSString *_videoUrl;
    NSString *_articleId;
    NSString *_articleTitle;

}

@property (nonatomic, retain) NSString *videoUrl;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *articleId;
@property (nonatomic, retain) NSString *articleTitle;

- (id)initWithURL:(NSString *)url andTitle:(NSString *)title;
- (void)GET;

@end

//
//  LeafContentViewController.h
//  Leaf
//
//  Created by roger on 13-1-29.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeafURLConnection.h"

@class LeafLoadingView;
@interface LeafContentViewController : UIViewController <UIWebViewDelegate, LeafURLConnectionDelegate>
{
    @private
    LeafLoadingView *_loading;
    UIWebView *_content;
    NSString *_url;
    LeafURLConnection *_connection;
}

- (id)initWithUrl:(NSString *)url;
@end

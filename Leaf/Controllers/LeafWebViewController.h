//
//  LeafWebViewController
//  Leaf
//
//  Created by roger qian on 12-12-3.
//  Copyright (c) 2012年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafWebViewController : LeafBaseViewController <UIActionSheetDelegate, UIWebViewDelegate>
{
    UIWebView *_mainWebView;
    NSURL *_url;
    UIButton *_goBackBtn;
    UIButton *_goForwardBtn;
}

@property (nonatomic, retain) NSURL *url;

- (id)initWithUrl:(NSURL *)url;

@end

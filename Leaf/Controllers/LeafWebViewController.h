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
    UIButton *_goBackBtn;
    UIButton *_goForwardBtn;
}

- (void)loadURL:(NSURL *)url;
- (void)loadContent:(NSString *)content;

@end

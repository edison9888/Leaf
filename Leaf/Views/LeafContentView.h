//
//  LeafContentView.h
//  Leaf
//
//  Created by roger qian on 13-3-20.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeafURLConnection.h"


typedef enum{
    LeafPanDirectionNone,
    LeafPanDirectionLeft,
    LeafPanDirectionRight
} LeafPanDirection;

typedef enum{
    LeafPanCompletionNone,
    LeafPanCompletionLeft,
    LeafPanCompletionRight
} LeafPanCompletion;

typedef enum {
    LeafPanStateNone,
    LeafPanStateShowingLeft,
    LeafPanStateShowingRight
} LeafPanState;

@protocol LeafContentViewDelegate

@optional
- (void)imgLinkClicked:(NSArray *)urls cur:(NSString *)url;

@end


@class LeafLoadingView;
@interface LeafContentView : UIView <UIWebViewDelegate, LeafURLConnectionDelegate>
{
@private
    LeafLoadingView *_loading;
    UIWebView *_content;
    NSString *_url;
    LeafURLConnection *_connection;
    NSString *_videoUrl;
    LeafPanDirection _panDirection;
    CGPoint _panVelocity;
    CGFloat _panOriginX;
    LeafPanState _state;
}

@property (nonatomic, assign) BOOL mask;
@property (nonatomic, retain) NSString *videoUrl; 
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) NSObject<LeafContentViewDelegate> *delegate;
- (void)loadURL:(NSString *)url;

@end



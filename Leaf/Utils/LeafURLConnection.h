//
//  LeafURLConnection.h
//  Leaf
//
//  Created by roger qian on 13-1-4.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LeafURLConnectionDelegate;

@interface LeafURLConnection : NSObject <NSURLConnectionDataDelegate>
{
    NSMutableData *_receivedData;
}
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, assign) NSObject <LeafURLConnectionDelegate> *delegate;

- (void)GET:(NSString *)urlStr;
- (void)POST:(NSString *)urlStr data:(NSData *)data;

- (void)cancel;

@end

@protocol LeafURLConnectionDelegate <NSObject>
@optional
- (void)didFinishLoadingData:(NSMutableData *)data;
- (void)didFailWithError:(NSError *)error;
- (void)connectionDidCancel;
@end
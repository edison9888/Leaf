//
//  LeafCommentModel.h
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeafURLConnection.h"

#define kLeafLoadCommentSuccess @"LeafLoadCommentSuccess"
#define kLeafLoadCommentFailed @"LeafLoadCommentFailed"
#define kLeafLoadCommentEmpty @"LeafLoadCommentEmpty"
#define kLeafLoadCommentCanceled @"LeafLoadCommentCanceled"

@interface LeafCommentData : NSObject
{
    NSString *_name;
    NSString *_time;
    NSString *_comment;
    NSString *_tid;
    NSString *_support;
    NSString *_against;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *tid;
@property (nonatomic, retain) NSString *support;
@property (nonatomic, retain) NSString *against;

@end

@interface LeafCommentModel : NSObject <LeafURLConnectionDelegate>
{
    LeafURLConnection *_connection;
    NSMutableArray *_dataArray;
    NSString *_referer;
}

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSString *referer;
- (void)load:(NSString *)articleId;
- (void)cancel;
- (void)support:(NSString *)tid;
- (void)against:(NSString *)tid;

@end

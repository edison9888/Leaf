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
#define kLeafLoadCommentCanceled @"LeafLoadCommentCanceled"

@interface LeafCommentData : NSObject
{
    NSString *_name;
    NSString *_time;
    NSString *_comment;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *comment;

@end

@interface LeafCommentModel : NSObject <LeafURLConnectionDelegate>
{
    LeafURLConnection *_connection;
    NSMutableArray *_dataArray;
}

@property (nonatomic, retain) NSMutableArray *dataArray;

- (void)load:(NSString *)articleId;
- (void)cancel;

@end

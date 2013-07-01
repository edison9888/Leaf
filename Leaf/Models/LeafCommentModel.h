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


@interface LeafCommentModel : NSObject <LeafURLConnectionDelegate>
{
    NSMutableArray *_dataArray;
    NSString *_articleId;
}

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSString *articleId;
- (void)load:(NSString *)articleId;
- (void)cancel;
- (void)support:(NSString *)tid;
- (void)against:(NSString *)tid;

@end

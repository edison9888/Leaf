//
//  LeafCommentData.h
//  Leaf
//
//  Created by roger on 13-7-1.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeafCommentData : NSObject
{
    NSString *_name;
    NSString *_time;
    NSString *_comment;
    NSString *_tid;
    NSString *_support;
    NSString *_against;
    LeafCommentData *_parent;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *tid;
@property (nonatomic, retain) NSString *support;
@property (nonatomic, retain) NSString *against;
@property (nonatomic, retain) LeafCommentData *parent;
@end

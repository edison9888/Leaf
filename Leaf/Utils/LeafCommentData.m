//
//  LeafCommentData.m
//  Leaf
//
//  Created by roger on 13-7-1.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCommentData.h"

@implementation LeafCommentData

@synthesize name = _name;
@synthesize time = _time;
@synthesize comment = _comment;
@synthesize tid = _tid;
@synthesize support = _support;
@synthesize against = _against;
@synthesize parent = _parent;

- (void)dealloc
{
    [_name release], _name = nil;
    [_time release], _time = nil;
    [_comment release], _comment = nil;
    [_tid release], _tid = nil;
    [_comment release], _comment = nil;
    [_against release], _against = nil;
    [_parent release], _parent = nil;
    
    [super dealloc];
}

@end


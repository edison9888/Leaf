//
//  LeafNewsData.m
//  Leaf
//
//  Created by roger qian on 13-1-28.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafNewsData.h"

@implementation LeafNewsData
@synthesize title, articleId, theme, pubTime, cmtNum;

- (void)dealloc
{
    [title release], title = nil;
    [articleId release], articleId = nil;
    [theme release], theme = nil;
    [pubTime release], pubTime = nil;
    [cmtNum release], cmtNum = nil;
    
    [super dealloc];
}

@end

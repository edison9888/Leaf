//
//  LeafReplyController.h
//  Leaf
//
//  Created by roger on 13-5-17.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafBaseViewController.h"

@interface LeafReplyController : LeafBaseViewController
{
    NSString *_articleId;
    NSString *_tid;
}

@property (nonatomic, retain) NSString *articleId;
@property (nonatomic, retain) NSString *tid;
@end

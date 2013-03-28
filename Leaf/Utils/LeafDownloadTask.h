//
//  LeafDownloadTask.h
//  Leaf
//
//  Created by roger qian on 13-3-27.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIWebPageRequest;
@interface LeafDownloadTask : NSOperation
{
    BOOL _finished;
    BOOL _executing;
    
}
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) ASIWebPageRequest *request;
- (id)initWithURL:(NSURL *)url;

@end

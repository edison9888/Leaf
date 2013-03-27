//
//  LeafDownloadTask.h
//  Leaf
//
//  Created by roger qian on 13-3-27.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeafDownloadTask : NSOperation
{
    BOOL _finished;
}
@property (nonatomic, retain) NSURL *url;

- (id)initWithURL:(NSURL *)url;

@end

//
//  LeafOfflineModel.h
//  Leaf
//
//  Created by roger on 13-4-24.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLeafOfflineFinished       @"LeafOfflineFinished"
#define kLeafOfflineUpdateProgress @"LeafOfflineUpdateProgress"
#define kLeafOfflineFailed         @"LeafOfflineFailed"

@interface LeafOfflineModel : NSObject

- (void)downloadNews;

@end

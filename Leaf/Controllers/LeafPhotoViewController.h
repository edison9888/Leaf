//
//  LeafPhotoViewController.h
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeafBaseViewController.h"

@interface LeafPhotoViewController : LeafBaseViewController <UIScrollViewDelegate>

- (id)initWithURLs:(NSArray *)urls;
- (void)setCurIndex:(int)index;
@end

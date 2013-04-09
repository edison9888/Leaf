//
//  LeafStack.h
//  Leaf
//
//  Created by roger on 13-4-8.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeafStack : NSObject

+ (LeafStack *)sharedInstance;

- (void)push:(UIViewController *)controller;
- (void)pop:(UIViewController *)controller;

@end

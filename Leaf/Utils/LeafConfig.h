//
//  LeafConfig.h
//  Leaf
//
//  Created by roger qian on 13-3-13.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeafConfig : NSObject
{
    BOOL _simple;
}

@property (nonatomic, assign) BOOL simple;

+ (id)sharedInstance;

@end

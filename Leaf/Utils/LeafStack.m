//
//  LeafStack.m
//  Leaf
//
//  Created by roger on 13-4-8.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafStack.h"
#import "Singleton.h"

@interface LeafStack ()
{
    NSMutableArray *_stack;
}

@end


@implementation LeafStack

SINGLETON_FOR_CLASS(LeafStack);


- (id)init
{
    if (self = [super init]) {
        _stack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)push:(UIViewController *)controller
{
    [_stack addObject:controller];
}

- (void)pop:(UIViewController *)controller
{
    int index = [_stack indexOfObject:controller];
    NSLog(@"index: %d", index);
    if (controller) {
        [_stack removeObject:controller];
    }
}

@end

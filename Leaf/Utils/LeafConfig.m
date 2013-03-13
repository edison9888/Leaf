//
//  LeafConfig.m
//  Leaf
//
//  Created by roger qian on 13-3-13.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafConfig.h"
#import "LeafHelper.h"

#define kSimpleMode @"SimpleMode"

@implementation LeafConfig
@synthesize simple = _simple;

static LeafConfig *_instance;

+ (id)sharedInstance
{
    @synchronized(self){
        if (!_instance) {
            [[self alloc] init];
        }
    }
    
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (!_instance) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return nil;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}



#pragma mark - 
#pragma mark - Leaf Config Stuff

- (void)setSimple:(BOOL)simple
{
    _simple = simple;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (_simple) {
        [ud setValue:__INT(1) forKey:kSimpleMode];
    }
    else
    {
        [ud setValue:__INT(0) forKey:kSimpleMode];
    }
}

- (void)refreshConfig
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int simpleCode = [ud integerForKey:kSimpleMode];
    if (simpleCode == 0) {
        _simple = NO;
    }
    else
    {
        _simple = YES;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        [self refreshConfig];
    }
    
    return self;
}



@end

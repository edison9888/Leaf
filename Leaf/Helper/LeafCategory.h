//
//  LeafCategory.h
//  Leaf
//
//  Created by roger qian on 13-1-15.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LeafHelper)

- (NSString *)urlDecode;

- (NSString *)urlEncode;

- (NSString *)safeFormat;

- (NSString *)stringByEncodeCharacterEntities;

@end


@interface NSArray (LeafHelper)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end


@interface NSDictionary (LeafHelper)

- (NSString *)stringForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;

@end


@interface NSMutableString (LeafHelper)

- (void)safeAppendString:(NSString *)string;

@end

@interface UIImage (LeafHelper)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage*)cropToSize:(CGSize)newSize;

@end
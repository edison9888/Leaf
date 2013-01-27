//
//  LeafCategory.m
//  Leaf
//
//  Created by roger qian on 13-1-15.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCategory.h"

#pragma mark-
#pragma mark NSString Categroy

@implementation NSString (LeafHelper)

- (NSString *)urlDecode
{
    if (self == nil || [self isEqualToString:@""]) {
        NSLog(@"urlDecode:msg is nil.");
        return nil;        
    }
    NSString *result = nil;
    result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)urlEncode
{
    if (self == nil || [self isEqualToString:@""]) {
        NSLog(@"urlEncode:msg is nil.");
        return nil;        
    }
    NSString *result = nil;
    result = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)safeFormat
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:self];
    NSString *numStr = [formatter stringFromNumber:number];
    [formatter release];
    return numStr;
}

@end


#pragma mark - 
#pragma mark NSArray Categroy

@implementation NSArray (LeafHelper)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (self.count > index) {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

@end


#pragma mark -
#pragma mark - NSDictionary Categroy

@implementation NSDictionary (LeafHelper)

- (NSString *)stringForKey:(NSString *)key
{
    NSObject *object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    }
    
    return @"";
}

- (int)intForKey:(NSString *)key
{
    NSObject *object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)object intValue];
    }
    else if([object isKindOfClass:[NSString class]]){
        return [(NSString *)object intValue];
    }
    else
    {
        NSLog(@"object can not represent as int.");
        return -1;
    }
}

@end

#pragma mark -
#pragma mark - NSMutableString Category

@implementation NSMutableString (LeafHelper)

-(void)safeAppendString:(NSString *)string
{
    if (string != nil) {
        [self appendString:string];
        return;
    }  
    
    NSLog(@"safeAppendingString: Are you kidding me? string is nil.");
    
}

@end

#pragma mark - 
#pragma mark - UIImage Category

@implementation UIImage (LeafHelper)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
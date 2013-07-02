//
//  LeafSQLiteManager.h
//  Leaf
//
//  Created by roger on 13-7-2.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"

@interface LeafSQLiteManager : NSObject
{
    sqlite3 *_db;
}

+ (LeafSQLiteManager *)sharedInstance;

- (BOOL)select:(NSString *)articleId;
- (int)insertRow:(NSString *)articleId;

@end

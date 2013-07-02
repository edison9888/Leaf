//
//  LeafSQLiteManager.m
//  Leaf
//
//  Created by roger on 13-7-2.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "Singleton.h"

#import "LeafSQLiteManager.h"

@interface LeafSQLiteManager ()

- (int)createTable;

@end

@implementation LeafSQLiteManager

SINGLETON_FOR_CLASS(LeafSQLiteManager);

- (id)init
{
    if (self = [super init]) {
        NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                    NSUserDomainMask,
                                                                    YES);
        NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"leaf_db"];
        
        if (sqlite3_open([databaseFilePath UTF8String], &_db) == SQLITE_OK) {
            [self createTable];
        }
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sqliteClose)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark - SQLite3 Utils

- (int)createTable
{
    char *errorMsg;
    const char *createSql="create table if not exists readed (id integer primary key autoincrement,articleId text)";
    
    if (sqlite3_exec(_db, createSql, NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"create ok.");
        return 0;
    }
    else {
        NSLog(@"error: %s",errorMsg);
        sqlite3_free(errorMsg);
        return -1;
    }
}

- (BOOL)select:(NSString *)articleId
{
    if (!_db) {
        NSLog(@"_db is invalid.");
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select id, articleId from readed WHERE articleId=\'%@\'", articleId];

    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_db, selectSql, -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            return YES;
        }
        return NO;
    }
    sqlite3_finalize(statement);
    return NO;
}

- (int)insertRow:(NSString *)articleId
{
    if (!_db) {
        NSLog(@"_db is invalid.");
        return -1;
    }
    char *errorMsg;
    NSString *sql = [NSString stringWithFormat:@"insert into readed (articleId) values(\'%@\')",articleId];
    const char *insertSql = [sql UTF8String];
    if (sqlite3_exec(_db, insertSql, NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"insert ok.");
        return 0;
    }
    return -1;
}

- (void)sqliteClose
{
    if (_db) {
        sqlite3_close(_db);
    }
}

@end

//
//  MoviesDatabase.m
//  MoviesProject
//
//  Created by Moussa Elenany on 9/10/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import "MoviesDatabase.h"

@implementation MoviesDatabase
-(instancetype)init{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        char *errMsg1,*errMsg2;
        const char *sql_stmt1 =
        "CREATE TABLE IF NOT EXISTS MOVIES (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, IMAGE TEXT, RATING FLOAT,RELEASEYEAR TEXT,GENRE TEXT)";
        const char *sql_stmt2 = "CREATE TABLE IF NOT EXISTS USERS (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,PHONE TEXT)";
        if (sqlite3_exec(_contactDB, sql_stmt1, NULL, NULL, &errMsg1) != SQLITE_OK || sqlite3_exec(_contactDB, sql_stmt2, NULL, NULL,&errMsg2 ))
        {
            printf("Can't create tables");
        }else{
            printf("Nice to create tables \n");
        }
        sqlite3_close(_contactDB);
    } else {
        NSLog(@"Failed to open/create database") ;
    }
    
    return self;
}
//check if ovies table is empty or not
-(BOOL)moviesTableEmpty{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    int rows =0;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT COUNT(*) MOVIES"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            rows = sqlite3_column_int(statement, 0);
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }else{
        printf("Database Connection lost");
    }
    
    if (rows == 0) {
        return YES;
    }else{
        return NO;
    }
}
@end

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
        "CREATE TABLE IF NOT EXISTS MOVIES (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, IMAGE TEXT, RATING TEXT,RELEASEYEAR TEXT,GENRE TEXT)";
        const char *sql_stmt2 = "CREATE TABLE IF NOT EXISTS USERS (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,PHONE TEXT)";
        if (sqlite3_exec(_contactDB, sql_stmt1, NULL, NULL, &errMsg1) != SQLITE_OK || sqlite3_exec(_contactDB, sql_stmt2, NULL, NULL,&errMsg2 ))
        {
            printf("Can't create tables");
        }else{
            //printf("Nice to create tables \n");
        }
        sqlite3_close(_contactDB);
    } else {
        NSLog(@"Failed to open/create database") ;
    }
    
    return self;
}
/*-(void)insetOneValue{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = @"INSERT INTO MOVIES ( TITLE , IMAGE , RATING ,RELEASEYEAR ,GENRE ) VALUES (\"yyyyy\",\"dddd\",\"5\",\"2017\",\"sss\")";
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            printf("Success");
        } else {
            printf("%s",sqlite3_errmsg(_contactDB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    


}*/
//check if movies table is empty or not
-(BOOL)moviesTableEmpty{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    int rows =0 ;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT COUNT(*) FROM MOVIES"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW){
                rows = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }else{
            printf("%s",sqlite3_errmsg(_contactDB));
        }
        sqlite3_close(_contactDB);
    }else{
        printf("Database Connection lost");
    }
    //printf("%d",rows);
    if (rows == 0) {
        return YES;
    }else{
        return NO;
    }
}
-(NSMutableArray *) showAllMovies{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSMutableArray *movies = [NSMutableArray new];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM MOVIES";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *genreArray ;
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                Movie *mov = [Movie new];

                [mov setTitle:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(
                                                                  statement, 1)]
                 ];
                [mov setImage:[[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 2)]
                 ] ;
                [mov setRating:[[NSNumber alloc] initWithFloat:sqlite3_column_double(statement, 3)] ];
                
                [mov setReleaseYear:[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 4)]];
                
                genreArray = [[[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 5)] componentsSeparatedByString:@","];
                [mov setGenre:genreArray];
                [movies addObject:mov];
            }
            sqlite3_finalize(statement);
        }else{
            printf("%s",sqlite3_errmsg(_contactDB));
        }
        sqlite3_close(_contactDB);
    }
    printf("%d",(int)movies.count);
         return movies;
}
//Stor data only at one time
-(void)insertMovieAtOnece:(NSMutableArray *)movies{
    if([self moviesTableEmpty] ){
        sqlite3_stmt    *statement;
        const char *dbpath = [_databasePath UTF8String];
        NSString * genreString ;
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            
            for (int i = 0 ; i< movies.count; i++) {
                genreString =[[[movies objectAtIndex:i] genre] componentsJoinedByString:@","];
                NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO MOVIES ( TITLE , IMAGE , RATING ,RELEASEYEAR,GENRE ) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[movies objectAtIndex:i] title],[[movies objectAtIndex:i] image],[[[movies objectAtIndex:i] rating] stringValue],[[movies objectAtIndex:i] releaseYear],genreString];
                
                //printf("%s",[genreString UTF8String]);
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(_contactDB, insert_stmt,
                                   -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    //printf("Success");
                } else {
                    printf("%s",sqlite3_errmsg(_contactDB));
                }
                sqlite3_finalize(statement);
                
            }
            sqlite3_close(_contactDB);
        }else{
            printf("Connection lost : %s",sqlite3_errmsg(_contactDB));
        }
        
        
        
    }

}

-(BOOL) searchForUserByPhone:(NSString *)phone{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    BOOL isFound = NO ;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT PHONE FROM USERS WHERE  PHONE = \"%@\"  LIMIT 1",phone];
        printf("in search func ");
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW){
                isFound = YES;
                printf("User IsFound");
            }else{
                printf("User not found");
            }
            
            sqlite3_finalize(statement);
        }else{
            printf("%s",sqlite3_errmsg(_contactDB));
        }
        sqlite3_close(_contactDB);
    }else{
        printf("Database Connection lost");
    }
    return isFound;

}
//check if Users table is empty or not
-(BOOL)searchForUser:(NSString*)name:(NSString *)phone{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
     BOOL isFound = NO ;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT PHONE FROM USERS WHERE NAME =\"%@\" AND PHONE = \"%@\"  LIMIT 1",name,phone];
        printf("in search func ");
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW){
                isFound = YES;
                printf("User IsFound");
            }else{
                printf("User not found");
            }
            
            sqlite3_finalize(statement);
        }else{
            printf("%s",sqlite3_errmsg(_contactDB));
        }
        sqlite3_close(_contactDB);
    }else{
        printf("Database Connection lost");
    }
    return isFound;

}
//register new user
-(void)RegisterNewUserIfNotExist:(NSString *)name :(NSString *)phone {
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (![self searchForUser:name:phone]) {
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO USERS (NAME,PHONE) VALUES (\"%@\",\"%@\")",name,phone];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_contactDB, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                printf("Success To register user");
            } else {
                printf("%s",sqlite3_errmsg(_contactDB));
            }
            sqlite3_finalize(statement);
            sqlite3_close(_contactDB);
        }else{
            printf("Connection lost");
        }

    }else{
       // printf("User is already registered");
    }
    
    
}
//drop table
-(void)dropTable{
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        char *errMsg1;
        const char *sql_stmt1 ="DROP TABLE MOVIES";
        if (sqlite3_exec(_contactDB, sql_stmt1, NULL, NULL, &errMsg1) != SQLITE_OK )
        {
            printf("%s",sqlite3_errmsg(_contactDB));
        }else{
            printf("table is down");
        }
        sqlite3_close(_contactDB);
    } else {
        NSLog(@"Failed to open/create database") ;
    }

}
@end

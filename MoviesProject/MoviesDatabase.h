//
//  MoviesDataBase.h
//  MoviesProject
//
//  Created by Moussa Elenany on 9/10/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Movie.h"
@interface MoviesDatabase : NSObject
    @property (strong , nonatomic) NSString *databasePath;
    @property (nonatomic) sqlite3 *contactDB;

    -(void)RegisterNewUserIfNotExist:(NSString*)name : (NSString *)phone;

    -(void)insertMovieAtOnece:(NSMutableArray *) movies;

    -(NSMutableArray *) showAllMovies;
    -(BOOL)searchForUser:(NSString *)name : (NSString *)phone;
    -(BOOL) moviesTableEmpty;
@end

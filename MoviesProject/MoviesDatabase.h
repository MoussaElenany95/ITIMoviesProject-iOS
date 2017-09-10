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
    -(BOOL)RegisterNewUser:(NSString*)name : (NSString *)phone;
    -(BOOL)insertMovieAtOnece:(Movie *) movie;
    -(NSMutableArray *) showAllMovies;
    -(BOOL) moviesTableEmpty;
@end
//
//  Movie.h
//  MoviesProject
//
//  Created by Mohamed Eshawy on 9/9/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Movie : JSONModel

@property NSString *title;
@property NSString *image;
@property NSNumber *rating;
@property NSString *releaseYear;
@property NSArray *genre;

@end

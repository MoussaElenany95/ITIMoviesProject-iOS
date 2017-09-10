//
//  TableTableViewController.h
//  MoviesProject
//
//  Created by Mohamed Eshawy on 9/9/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONModel.h>
#import <AFNetworking.h>
#import "Movie.h"
#import "MoviesDatabase.h"
#import "MovieDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface TableViewController : UITableViewController{
    MoviesDatabase *movDb;
    MovieDetailsViewController *movieDetailsViewObject;
    UIStoryboard *storyboard;

}

@property NSMutableArray *Movies;
@property NSMutableArray *images;


@end

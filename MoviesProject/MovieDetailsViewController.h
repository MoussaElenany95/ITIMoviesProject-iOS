//
//  MovieDetailsViewController.h
//  MoviesProject
//
//  Created by Hussein on 9/11/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <HCSStarRatingView.h>


@interface MovieDetailsViewController : UIViewController

@property Movie *movie;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *releaseYearLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@end


//
//  MovieDetailsViewController.m
//  MoviesProject
//
//  Created by Hussein on 9/11/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_titleLabel setText:[_movie title]];
    [_releaseYearLabel setText:[_movie releaseYear]];
    [_ratingLabel setText:[_movie.rating stringValue]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_movie image]]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

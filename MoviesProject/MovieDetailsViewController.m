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
-(void)viewWillAppear:(BOOL)animated{

    [_titleLabel setText:[_movie title]];
    [_releaseYearLabel setText:[_movie releaseYear]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_movie image]]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    

    
    NSString *createdString = [[_movie genre] componentsJoinedByString:@" "];
    [_genreLabel setText:createdString];
    
    
    
    
    
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(60, 424, 200, 50)];
    starRatingView.allowsHalfStars = YES;
    [starRatingView setBackgroundColor:[[UIColor alloc] initWithRed:0.92193537950000004 green:0.69741988180000003 blue:0.18115940689999999 alpha:1]];
    starRatingView.allowsHalfStars = YES;
    starRatingView.maximumValue = 10;
    starRatingView.minimumValue = 0;
    starRatingView.value = _movie.rating.floatValue;

    starRatingView.tintColor = [UIColor yellowColor];
    //[starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
    

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Details"];
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

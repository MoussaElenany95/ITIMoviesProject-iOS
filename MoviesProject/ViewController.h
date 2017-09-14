//
//  ViewController.h
//  MoviesProject
//
//  Created by Moussa Elenany on 9/9/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController<UIAlertViewDelegate>
{

}
@property (weak, nonatomic) IBOutlet UITextField *nameLogin;
@property (weak, nonatomic) IBOutlet UITextField *phoneLogin;
- (IBAction)signButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end


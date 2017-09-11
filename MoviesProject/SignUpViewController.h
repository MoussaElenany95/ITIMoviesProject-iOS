//
//  SignUpViewController.h
//  MoviesProject
//
//  Created by Hussein on 9/10/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameSign;
@property (weak, nonatomic) IBOutlet UITextField *phoneSign;
- (IBAction)CreateButton:(id)sender;



@end

//
//  SignUpViewController.m
//  MoviesProject
//
//  Created by Hussein on 9/10/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import "SignUpViewController.h"
#import "ViewController.h"
#import <AFNetworking.h>
#import "myJSON.h"
#import <JSONModel.h>
#import "TableViewController.h"

@interface SignUpViewController (){
    MoviesDatabase* movDb;
    NSString *name;
    NSString *phone;
    NSString *myurl;
    myJSON *json;


}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    movDb = [MoviesDatabase new];
    
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

- (IBAction)CreateButton:(id)sender {
    name=[_nameSign text];
    phone=[_phoneSign text];
    NSNumberFormatter *formater =[NSNumberFormatter new];
    [formater setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *phoneNumber = [formater numberFromString:phone];
    NSNumber *nameNumber  = [formater numberFromString:name];
    
    UIAlertController *dataAlert;
    UIAlertAction *okAction;
    NSUserDefaults *appUserDefaults = [NSUserDefaults standardUserDefaults];
    
    //check if data successfuly enterd or not
    if ([name isEqualToString:@""] || [phone isEqualToString:@""]) {
        dataAlert = [UIAlertController alertControllerWithTitle:@"Dismissing data" message:@"Data must be filled" preferredStyle:UIAlertControllerStyleAlert];
        okAction =[UIAlertAction actionWithTitle: @"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            ////////////////////////////////////
            
        }];
        [dataAlert addAction:okAction];
        
        [self presentViewController:dataAlert animated:YES completion:nil];
    }
    
    else if(!phoneNumber || nameNumber) {
        
        //Invalied Data Alert
        dataAlert = [UIAlertController alertControllerWithTitle:@"Invalid data" message:@"Please Enter vailed data" preferredStyle:UIAlertControllerStyleAlert];
        okAction =[UIAlertAction actionWithTitle: @"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            ///Ok I understand
            
        }];
        [dataAlert addAction:okAction];
        
        [self presentViewController:dataAlert animated:YES completion:nil];
    }

    if (![appUserDefaults boolForKey:@"isOffline"]) {
        if (![movDb searchForUserByPhone:phone]) {
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            myurl =[[NSString alloc] initWithFormat:@"http://jets.iti.gov.eg/FriendsApp/services/user/register?name=%@&phone=%@",name,phone];
            NSURL *URL = [NSURL URLWithString:myurl];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    json=[[myJSON alloc] initWithDictionary:responseObject error:nil];
                    if([json.result isEqualToString:@"User registered Successfuly"]){
                        [movDb RegisterNewUserIfNotExist:name :phone];
                        [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TableNavigationController"] sender:self];
                    }
                    else if([json.result isEqualToString:@"This Phone is already Registered."]){
                        
                        [movDb RegisterNewUserIfNotExist:name :phone];
                        [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TableNavigationController"] sender:self];
                    }
                }
            }];
            [dataTask resume];
            
        }else{
            UIAlertController *signUpAlert = [UIAlertController alertControllerWithTitle:@"SignUp failed" message:@"User phone Is already registered" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction =[UIAlertAction actionWithTitle: @"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //Cancel
                
            }];
            [signUpAlert addAction:cancelAction];
            [self presentViewController:signUpAlert animated:YES completion:nil];
            
        }
        
    }else{
        
        //Offline mode
        dataAlert = [UIAlertController alertControllerWithTitle:@"No Internet Access" message:@"Please check your Network" preferredStyle:UIAlertControllerStyleAlert];
        okAction =[UIAlertAction actionWithTitle: @"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            ///Ok I understand
            
        }];
        [dataAlert addAction:okAction];
        
        [self presentViewController:dataAlert animated:YES completion:nil];
    
    }
    
    }
@end

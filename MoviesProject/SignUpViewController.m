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
    [self.spinner setHidden:YES];
    [self.spinner setColor:[UIColor redColor]];
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
//loading function
-(void)loading:(BOOL)isLoading{
    //Loading
    if (isLoading) {
        [self.spinner setHidden:NO];
        [self.spinner startAnimating];
        [self.createAcountButton setEnabled:NO];
        [self.createAcountButton setTitle:@"Loading" forState:UIControlStateDisabled];
    }else{
        [self.spinner stopAnimating];
        [self.spinner setHidden:YES];
        [self.createAcountButton setEnabled:YES];
    }
    
}
- (IBAction)CreateButton:(id)sender {
    //loading
    [self loading:YES];
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
            
            [self loading:NO];
        }];
        [dataAlert addAction:okAction];
        
        [self presentViewController:dataAlert animated:YES completion:nil];
    }
    
    else if(!phoneNumber || nameNumber) {
        
        //Invalied Data Alert
        dataAlert = [UIAlertController alertControllerWithTitle:@"Invalid data" message:@"Please Enter vailed data" preferredStyle:UIAlertControllerStyleAlert];
        okAction =[UIAlertAction actionWithTitle: @"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            ///Ok I understand
            [self loading:NO];
            
        }];
        [dataAlert addAction:okAction];
        
        [self presentViewController:dataAlert animated:YES completion:nil];
    }
    else{
        if (![appUserDefaults boolForKey:@"isOffline"]) {
           
            //Search for user by phone
            if (![movDb searchForUserByPhone:phone]) {
                
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                myurl =[[NSString alloc] initWithFormat:@"http://jets.iti.gov.eg/FriendsApp/services/user/register?name=%@&phone=%@",name,phone];
                NSURL *URL = [NSURL URLWithString:myurl];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                
                NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (error) {
                        UIAlertController *connAlert = [UIAlertController alertControllerWithTitle:@"Connection Lost" message:@"Check your Internet" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction =[UIAlertAction actionWithTitle: @"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self loading:NO];
                        }];
                        [connAlert addAction:okAction];
                        [self presentViewController:connAlert animated:YES completion:nil];
                    } else {
                        json=[[myJSON alloc] initWithDictionary:responseObject error:nil];
                        if([json.result isEqualToString:@"User registered Successfuly"]){
                            [movDb RegisterNewUserIfNotExist:name :phone];
                            [appUserDefaults setBool:YES forKey:@"isRegistered"];
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
                    [self loading:NO];
                }];
                [signUpAlert addAction:cancelAction];
                [self presentViewController:signUpAlert animated:YES completion:nil];
                
            }
            
        }else{
            
            //Offline mode
            dataAlert = [UIAlertController alertControllerWithTitle:@"No Internet Access" message:@"Please check your Network" preferredStyle:UIAlertControllerStyleAlert];
            okAction =[UIAlertAction actionWithTitle: @"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                ///Ok I understand
                [self loading:NO];
                
            }];
            [dataAlert addAction:okAction];
            
            [self presentViewController:dataAlert animated:YES completion:nil];
            
        }

        
    }
    
    }
@end

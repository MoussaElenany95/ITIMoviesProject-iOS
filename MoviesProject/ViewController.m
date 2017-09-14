//
//  ViewController.m
//  MoviesProject
//
//  Created by Moussa Elenany on 9/9/17.
//  Copyright © 2017 Moussa Elenany. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "myJSON.h"
#import <JSONModel.h>
#import "MoviesDatabase.h"
#import "SignUpViewController.h"
#import "TableViewController.h"

@interface ViewController (){
    
    MoviesDatabase *movDb;
    NSString *name;
    NSString *phone;
    NSString *myurl;
    myJSON *json;
    NSUserDefaults *appUserDefault;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    [self.spinner setHidden:YES];
    [self.spinner setColor:[UIColor redColor]];
    appUserDefault =[NSUserDefaults standardUserDefaults];
    
    //intialize DataBase
    movDb =[MoviesDatabase new];
    
    if ([appUserDefault boolForKey:@"isRegistered"]) {
        [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TableNavigationController"] sender:self];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loading:(BOOL)isLoading{
    //Loading
    if (isLoading) {
        [self.spinner setHidden:NO];
        [self.spinner startAnimating];
        [self.loginButton setEnabled:NO];
        [self.loginButton setTitle:@"Loading" forState:UIControlStateDisabled];
    }else{
        [self.spinner stopAnimating];
        [self.spinner setHidden:YES];
        [self.loginButton setEnabled:YES];
    }
    
}
- (IBAction)signButton:(id)sender {
    
    UIAlertController *dataAlert;
    UIAlertAction *okAction;
    UIAlertAction *cancelAction;
    [self loading:YES];
    //User Inputs
    name=[_nameLogin text];
    phone=[_phoneLogin text];
    NSNumberFormatter *formater =[NSNumberFormatter new];
    [formater setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *phoneNumber = [formater numberFromString:phone];
    NSNumber *nameNumber  = [formater numberFromString:name];
    
    
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
            
            [self loading:NO];
            
        }];
        [dataAlert addAction:okAction];
        
        [self presentViewController:dataAlert animated:YES completion:nil];
    }
    else{
        
        //Offline alert if conection lost
        dataAlert = [UIAlertController alertControllerWithTitle:@"Connection lost" message:@"No Internet Access" preferredStyle:UIAlertControllerStyleAlert];
        okAction =[UIAlertAction actionWithTitle:@"Go Offline mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [appUserDefault setBool:YES forKey:@"isRegistered"];
                [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TableNavigationController"] sender:self];
        }];
        cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //cancel loading state
            [self loading:NO];
        }];

        [dataAlert addAction:okAction];
        [dataAlert addAction:cancelAction];
        ///////////////////////////////////////
        
        //Search for user
        if([movDb searchForUser:name:phone] ){
            //check if offline or not
            if (![appUserDefault boolForKey:@"isOffline"]) {
                    
                        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                        myurl =[[NSString alloc] initWithFormat:@"http://jets.iti.gov.eg/FriendsApp/services/user/register?name=%@&phone=%@",name,phone];
                        NSURL *URL = [NSURL URLWithString:myurl];
                        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                            if (error) {
                                [self presentViewController:dataAlert animated:YES completion:nil];
                            } else {
                                json=[[myJSON alloc] initWithDictionary:responseObject error:nil];
                                if([json.result isEqualToString:@"This Phone is already Registered."]){
                                    //register user in local database if not exist
                                    
                                    [appUserDefault setBool:YES forKey:@"isRegistered"];
                                    
                                    [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TableNavigationController"] sender:self];
                                    
                                }
                                
                            }
                        }];
                        [dataTask resume];
                        
                    
                }else{
                    [self presentViewController:dataAlert animated:YES completion:nil];
                    
                }
            
        }else{
            UIAlertController *signUpAlert =[UIAlertController alertControllerWithTitle:@"User not Found" message:@"User not found , Signup now ? " preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *signUpAction =[UIAlertAction actionWithTitle:@"SignUp" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //stop loading
                [self loading:NO];
                //Go to Sign up view
                [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"signup"] animated:YES];
                
                
            }];
            UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self loading:NO];
                
            }];
            [signUpAlert addAction:signUpAction];
            [signUpAlert addAction:cancelAction];
            
            [self presentViewController:signUpAlert animated:YES completion:nil];
            
            
        }
    
    }
}

@end

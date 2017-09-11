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
#import "SignUpViewController.h"
#import "TableViewController.h"

@interface ViewController (){
    NSString *name;
    NSString *phone;
    NSString *myurl;
    myJSON *json;


}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signButton:(id)sender {
    name=[_nameLogin text];
    phone=[_phoneLogin text];
    NSNumberFormatter *formater =[NSNumberFormatter new];
    [formater setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *phoneNumber = [formater numberFromString:phone];
    NSNumber *nameNumber  = [formater numberFromString:name];
    
    UIAlertController *dataAlert;
    UIAlertAction *okAction;
    
    //user sefaults to check offline mode
    NSUserDefaults *appUserDefault = [NSUserDefaults standardUserDefaults];
    
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
            
            
            
        }];
        [dataAlert addAction:okAction];
        
        [self presentViewController:dataAlert animated:YES completion:nil];
    }
    else{
        //Offline alert if conection lost
        dataAlert = [UIAlertController alertControllerWithTitle:@"Connection lost" message:@"No Internet Access" preferredStyle:UIAlertControllerStyleAlert];
        okAction =[UIAlertAction actionWithTitle:@"Go Offline mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
                [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TableNavigationController"] sender:self];
        }];
        [dataAlert addAction:okAction];
        ///////////////////////////////////////
    
        //check if offline or not
        if (![appUserDefault boolForKey:@"isOffline"]) {
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
                if([json.result isEqualToString:@"This Phone is already Registered."]){
                    
                    [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TableNavigationController"] sender:self];
                    
                }
                else
                {
                    UIAlertController *signUpAlert =[UIAlertController alertControllerWithTitle:@"User not Found" message:@"User not found , Signup now ? " preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *signUpAction =[UIAlertAction actionWithTitle:@"SignUp" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        //Go to Sign up view
                        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"signup"] animated:YES];
                        
                    
                    }];
                    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        //Cancel
                        
                    }];
                    [signUpAlert addAction:signUpAction];
                    [signUpAlert addAction:cancelAction];
                    
                    [self presentViewController:signUpAlert animated:YES completion:nil];
                    
                }
                
            }
            }];
            [dataTask resume];
        
        

        }else{
            [self presentViewController:dataAlert animated:YES completion:nil];
        }
    
    }
}
@end

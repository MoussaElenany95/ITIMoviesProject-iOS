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
                 [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"signup"] animated:YES];
                
            }
            
        }
    }];
    [dataTask resume];
   
    

    
}
@end

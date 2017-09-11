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
                 [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TableNavigationController"] sender:self];
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }];
    [dataTask resume];
    }

@end

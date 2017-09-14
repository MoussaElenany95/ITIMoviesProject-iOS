

#import "TableViewController.h"

@interface TableViewController (){
    NSUserDefaults *appUserDefault;
}

@end

@implementation TableViewController
-(void)loading:(BOOL)isLoading{
    //Loading
    if (isLoading) {
        [spinner setHidden:NO];
        [spinner startAnimating];
        
    }else{
        [spinner stopAnimating];
        [spinner setHidden:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner setColor:[UIColor redColor]];
    [spinner setFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *loadingbutton = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    [self navigationItem].rightBarButtonItem = loadingbutton;
    //loading data;
    movieDetailsViewObject = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsView"];
    
    appUserDefault = [NSUserDefaults standardUserDefaults];
    
    self.Movies=[[NSMutableArray alloc]init];
    movDb =[MoviesDatabase new];
    [self loading:YES];
    if ([appUserDefault boolForKey:@"isOffline"] == NO) {
       
        //loading data;

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:@"https://api.androidhive.info/json/movies.json"];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                printf("Downloading error");
            } else {
                for (int i=0; i<[responseObject count]; i++) {
                    Movie *movie=[[Movie alloc]initWithDictionary:[responseObject objectAtIndex:i] error:nil];
                    [self.Movies addObject:movie];
                }
                [self loading:NO];
                [self.tableView reloadData];
                [movDb insertMovieAtOnece:self.Movies];
            }
        }];
        [dataTask resume];
        //double delay=0.1;
        //[NSThread sleepForTimeInterval:delay];
        
        
        
    }else{
        printf("Is offline");
        self.Movies = [movDb showAllMovies];
    }
    
    

    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear =YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [self.Movies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Movie *movie=[self.Movies objectAtIndex:indexPath.row];
    NSString *url=movie.image;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Icon.png"] options:SDWebImageRefreshCached];
    cell.detailTextLabel.text=movie.releaseYear;
    cell.textLabel.text=movie.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [movieDetailsViewObject setMovie: [self.Movies objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:movieDetailsViewObject animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)logOutPressed:(id)sender {
    UIAlertController *logOutAlert =[UIAlertController alertControllerWithTitle:@"Log Out" message:@"Are you sure ?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *signUpAction =[UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [appUserDefault setBool:NO forKey:@"isRegistered"];
        //Go to Sign up view
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Login"] animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //Cancel
        
    }];
    [logOutAlert addAction:signUpAction];
    [logOutAlert addAction:cancelAction];
    
    [self presentViewController:logOutAlert animated:YES completion:nil];
}
@end

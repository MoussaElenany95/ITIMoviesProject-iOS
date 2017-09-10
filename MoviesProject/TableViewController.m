

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    movieDetailsViewObject = [storyboard instantiateViewControllerWithIdentifier:@"DetailsView"];

    
    
    
    self.Movies=[[NSMutableArray alloc]init];
    movDb =[MoviesDatabase new];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://api.androidhive.info/json/movies.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            UIAlertController *errAlert = [UIAlertController alertControllerWithTitle:@"Connection lost" message:@"No Internet Access" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"Go Offline mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                printf("Offline mode");
                
                if([movDb moviesTableEmpty]){
                    printf("NO Data found in Ofline mode");
                }
                else{
                    self.Movies = [movDb showAllMovies];
                }
                
            }];
            [errAlert addAction:okAction];
            [self presentViewController:errAlert animated:YES completion:nil];

        } else {
            for (int i=0; i<[responseObject count]; i++) {
                Movie *movie=[[Movie alloc]initWithDictionary:[responseObject objectAtIndex:i] error:nil];
                [self.Movies addObject:movie];
            }
        }
    }];
    [dataTask resume];
    
    double delay=0.1;
    [NSThread sleepForTimeInterval:delay];


    
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
//    NSString *url=movie.image;
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Icon.png"] options:SDWebImageRefreshCached];
    cell.detailTextLabel.text=movie.releaseYear;
    cell.textLabel.text=movie.title;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    Movie * obj = [_Movies objectAtIndex:indexPath.row];
    [movieDetailsViewObject setMovie: obj];
    
    [self showViewController:movieDetailsViewObject sender:self];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

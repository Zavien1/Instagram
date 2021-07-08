//
//  FeedViewController.m
//  Instagram
//
//  Created by Zavien Sibilia on 7/6/21.
//

#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "ComposeViewController.h"
#import "SceneDelegate.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arrayOfPosts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self fetchPosts];
}

- (void)fetchPosts {
    // construct PFQuery
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Instagram_Posts"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"text"];
    [postQuery includeKey:@"image"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"Error querying for data %@", error.localizedDescription);
        }
    }];
    
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"successfully Logged out");
        }
    }];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *post = self.arrayOfPosts[indexPath.row];
    
    cell.postTextLabel.text = post[@"text"];
    
    //Displaying image
    PFFileObject *image = post[@"image"];
    [cell.postImage setImageWithURL:[NSURL URLWithString:image.url]];
    
    return cell;
    
}

- (void)didPost{
    [self fetchPosts];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.arrayOfPosts count]){
//        [self fetchPosts:[self.arrayOfPosts count] + 20];
        [self fetchPosts];
    }
}

//-(void)loadMoreData{
//    
//      // ... Create the NSURLRequest (myRequest) ...
//    
//    // Configure session so that completion handler is executed on main UI thread
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session  = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *requestError) {
//        if (requestError != nil) {
//            NSLog(@"Error querying for data %@", requestError.localizedDescription);
//        }
//        else
//        {
//            self.isMoreDataLoading = false;
//            [self fetchPosts];
//            [self.tableView reloadData];
//        }
//    }];
//    [task resume];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // Handle scroll behavior here
//    if(!self.isMoreDataLoading){
//        self.isMoreDataLoading = true;
//        
//        // Calculate the position of one screen length before the bottom of the results
//        int scrollViewContentHeight = self.tableView.contentSize.height;
//        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
//        
//        // When the user has scrolled past the threshold, start requesting
//        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
//            self.isMoreDataLoading = true;
//            [self loadMoreData];
//        }
//    }
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"detailsView"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.arrayOfPosts[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    else if([segue.identifier isEqual:@"composeView"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeViewController = (ComposeViewController*)navigationController.topViewController;
        composeViewController.delegate = self;
    }
    
}


@end

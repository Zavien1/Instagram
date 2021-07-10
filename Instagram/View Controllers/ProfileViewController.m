//
//  ProfileViewController.m
//  Instagram
//
//  Created by Zavien Sibilia on 7/9/21.
//

#import "ProfileViewController.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
#import "Parse/Parse.h"
#import "PostCollectionCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) NSMutableArray* userDataArray;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchData];
    
    UICollectionViewFlowLayout *layout =(UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    CGFloat postsPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - 1 - layout.minimumInteritemSpacing * (postsPerLine - 1)/ postsPerLine);
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchData {
    // construct PFQuery
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Instagram_Posts"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"image"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if(posts){
            self.userDataArray = posts;
            [self updateUserProfile];
            [self.collectionView reloadData];
        }
        else{
            NSLog(@"Error querying for data %@", error.localizedDescription);
        }
    }];
}

- (void)updateUserProfile {
    PFUser *user = [PFUser currentUser];
    self.userNameLabel.text = user.username;
    PFFileObject *image = user[@"userProfileImage"];
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:image.url]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.userDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *post = self.userDataArray[indexPath.item];
    
    PFFileObject *image = post[@"image"];
    [cell.postImage setImageWithURL:[NSURL URLWithString:image.url]];
    
    return cell;
}

/*
 #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

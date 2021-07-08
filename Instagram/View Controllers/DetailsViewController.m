//
//  DetailsViewController.m
//  Instagram
//
//  Created by Zavien Sibilia on 7/7/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Parse/Parse.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *postUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postTextLabel.text = self.post[@"text"];
    self.postTimeLabel.text = [self.post createdAt].shortTimeAgoSinceNow;
    
    PFFileObject *image = self.post[@"image"];
    [self.postImage setImageWithURL:[NSURL URLWithString:image.url]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
}
*/

@end

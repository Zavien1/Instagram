//
//  DetailsViewController.m
//  Instagram
//
//  Created by Zavien Sibilia on 7/7/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Parse/Parse.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *postUserLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postTextLabel.text = self.post[@"text"];
    
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

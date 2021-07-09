//
//  PostCell.m
//  Instagram
//
//  Created by Zavien Sibilia on 7/6/21.
//

#import "PostCell.h"
#import "Parse/Parse.h"
#import "DateTools.h"
#import "UIImageView+AFNetworking.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapLike:(id)sender {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Instagram_Posts"];
    [postQuery whereKey:@"objectId" equalTo:self.post.objectId];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(posts != nil){
            Post *queriedPost = posts[0];
            NSMutableArray *usersWhoLiked = queriedPost[@"users_who_liked"];
            
            if([usersWhoLiked containsObject:[PFUser currentUser].username]) {
                NSNumber *numberOfLikes = queriedPost[@"likes"];
                NSNumber *newLikes = [NSNumber numberWithInt:([numberOfLikes intValue] - 1)];
                queriedPost[@"likes"] = newLikes;
                
                [usersWhoLiked removeObject:[PFUser currentUser].username];
                queriedPost[@"users_who_liked"] = usersWhoLiked;
                
                [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
                
            }
            else{
                NSNumber *numberOfLikes = queriedPost[@"likes"];
                NSNumber *newLikes = [NSNumber numberWithInt:([numberOfLikes intValue] + 1)];
                queriedPost[@"likes"] = newLikes;
                
                [usersWhoLiked addObject:[PFUser currentUser].username];
                queriedPost[@"users_who_liked"] = usersWhoLiked;
                [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-1"] forState:UIControlStateNormal];
            }
            
            [queriedPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                    NSLog(@"Failed to like post %@", error.localizedDescription);
                }
                else{
                    [self generateCell:queriedPost];
                }
            }];
        }
        else{
            NSLog(@"error %@", error.localizedDescription);
        }
    }];
}

- (void)generateCell:(Post *)post {
    self.post = post;
    PFUser *user = post[@"user"];
//    self.postUserLabel.text = user.username;
    self.postTextLabel.text = post[@"text"];
    self.postTimeLabel.text = [post createdAt].shortTimeAgoSinceNow;
    
    if([post[@"likes"] intValue] == 1){
        self.postLikesLabel.text = [NSString stringWithFormat:@"%@ like", post[@"likes"]];
    }
    else{
        self.postLikesLabel.text = [NSString stringWithFormat:@"%@ likes", post[@"likes"]];
    }
    
    //check if user already liked post on load so that like button is highlighted
    if([post[@"users_who_liked"] containsObject:[PFUser currentUser].username]){
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-1"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    
    
    PFFileObject *image = post[@"image"];
    [self.postImage setImageWithURL:[NSURL URLWithString:image.url]];
}

@end

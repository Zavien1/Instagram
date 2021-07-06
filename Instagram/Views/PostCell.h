//
//  PostCell.h
//  Instagram
//
//  Created by Zavien Sibilia on 7/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;

@end

NS_ASSUME_NONNULL_END

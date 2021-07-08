//
//  ComposeViewController.m
//  Instagram
//
//  Created by Zavien Sibilia on 7/6/21.
//

#import "ComposeViewController.h"
#import "SceneDelegate.h"
#import "Post.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *imagePost;
@property (weak, nonatomic) IBOutlet UITextField *postTextField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
}
- (IBAction)didTapImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGSize imageSize = CGSizeMake(300, 300);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:imageSize];
    
    self.imagePost = resizedImage;
    self.imageView.image = resizedImage;
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    Post *post = [PFObject objectWithClassName:@"Instagram_Posts"];
    post[@"text"] = self.postTextField.text;
    post[@"user"] = PFUser.currentUser;
    NSData *imageData = UIImagePNGRepresentation(self.imagePost);
    post[@"image"] = [PFFileObject fileObjectWithName:@"image.png" data:imageData contentType:@"image/png"];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate didPost];
        }
        else{
            NSLog(@"Error posting picture %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

#import "NewPhotoViewController.h"

#import "PhotoAlbum.h"

@interface NewPhotoViewController ()

@end

@implementation NewPhotoViewController

- (void)viewDidLoad {
  UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
  imagePickerController.delegate = self;
  [self addChildViewController:imagePickerController];
  [self.view addSubview:imagePickerController.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
  [PhotoAlbum savePhoto:image];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
}


@end

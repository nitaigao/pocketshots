#import "ImportPhotosViewController.h"

#import "PhotoAlbum.h"

@interface ImportPhotosViewController ()

@end

@implementation ImportPhotosViewController

- (void)viewDidAppear:(BOOL)animated {
  QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
  imagePickerController.delegate = self;
  imagePickerController.allowsMultipleSelection = YES;
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
  [self addChildViewController:navigationController];
  [self.view addSubview:navigationController.view];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
  __block NSInteger index = 0;
  for (ALAsset* assetURL in assets) {
    [PhotoAlbum importPhoto:assetURL.defaultRepresentation.url complete:^{
      if (index + 1 >= assets.count) {
        [self dismissViewControllerAnimated:YES completion:nil];
      }
      index++;
    }];
  }
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end

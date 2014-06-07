#import "PhotoViewController.h"

@interface PhotoViewController ()
- (void)viewTapped;
@end

@implementation PhotoViewController

@synthesize photoPath, creationDate, index, photo;

- (void)viewTapped {
  [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:YES];
}

- (void)viewDidLoad {
  UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
  [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
  if (photo.image == nil) {
    photo.image = [UIImage imageWithContentsOfFile:photoPath];
  }
}



@end

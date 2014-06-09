#import "ImportSelectPhotosViewController.h"

#import "PhotoAlbum.h"

#import "ImportProcessingPhotosViewController.h"

@interface ImportSelectPhotosViewController ()

@end

@implementation ImportSelectPhotosViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    photosToImport = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
  imagePickerController.delegate = self;
  imagePickerController.allowsMultipleSelection = YES;
  
  navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:YES];
  [self addChildViewController:navigationController];
  [self.view addSubview:navigationController.view];
}

- (void)viewDidDisappear:(BOOL)animated {
  [navigationController removeFromParentViewController];
  [navigationController.view removeFromSuperview];
  [self.navigationController setNavigationBarHidden:NO];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
  [photosToImport removeAllObjects];
  for (ALAsset* asset in assets) {
    [photosToImport addObject:asset.defaultRepresentation.url];
  }
  [self performSegueWithIdentifier:@"importing" sender:self];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  ImportSelectPhotosViewController* selectViewController = segue.sourceViewController;
  ImportProcessingPhotosViewController* processingViewController = segue.destinationViewController;
  
  [processingViewController addPhotosToProcess:selectViewController->photosToImport];
}

@end

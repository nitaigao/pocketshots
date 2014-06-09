#import "TimelineViewController.h"

#import "PhotoAlbum.h"

#import "PhotoViewController.h"
#import "ImportSelectPhotosViewController.h"
#import <QBImagePickerController/QBImagePickerController.h>

@interface TimelineViewController ()

@end

@implementation TimelineViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    controllers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  self.dataSource = self;
//  [PhotoAlbum purgeAlbum];
}

- (IBAction)newPhoto:(id)sender {
  [self performSegueWithIdentifier:@"photo" sender:self];
}

- (IBAction)trashPhoto:(id)sender {
  PhotoViewController* viewController = self.viewControllers.firstObject;
  [viewController purge];
  
  [controllers removeObjectAtIndex:viewController.index];
  
  if (controllers.count <= 0) {
    UIViewController* noPhotosController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoPhotos"];
    [self setViewControllers:@[noPhotosController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    [controllers addObject:noPhotosController];
  }
  else {
    if (viewController.index == 0) {
      PhotoViewController* previousViewController = [controllers objectAtIndex:0];
      [self setViewControllers:@[previousViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    else {
      PhotoViewController* previousViewController = [controllers objectAtIndex:viewController.index - 1];
      [self setViewControllers:@[previousViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
  }
  
  for (NSInteger i = 0; i < controllers.count; i++) {
    PhotoViewController* controller = [controllers objectAtIndex:i];
    controller.index = i;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setToolbarHidden:YES animated:NO];
  [controllers removeAllObjects];
  
  [PhotoAlbum iterateImages:^(NSString* photoPath, NSDate* creationDate, NSInteger photoIndex, NSInteger totalPhotos) {
    
    PhotoViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    viewController.photoPath = photoPath;
    viewController.creationDate = creationDate;
    [controllers addObject:viewController];
    
    if (photoIndex + 1 >= totalPhotos) {
      [controllers sortUsingComparator:^NSComparisonResult(PhotoViewController* a, PhotoViewController* b) {
        return [a.creationDate compare:b.creationDate];
      }];
      
      for (NSInteger i = 0; i < totalPhotos; i++) {
        PhotoViewController* controller = [controllers objectAtIndex:i];
        controller.index = i;
        
        if (i + 1 == totalPhotos) {
          [self setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionReverse animated:false completion:nil];
        }
      }
    }
  }];
  
  if (controllers.count <= 0) {
    UIViewController* noPhotosController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoPhotos"];
    [self setViewControllers:@[noPhotosController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    [controllers addObject:noPhotosController];
  }

  
//  if (PhotoAlbum.photoCount <= 0) {
//    [self performSegueWithIdentifier:@"setup" sender:self];
//  }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(PhotoViewController *)viewController {
  if (viewController.index - 1 < 0) {
    return nil;
  }
  
  UIViewController* previousController = [controllers objectAtIndex:viewController.index - 1];
  return previousController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(PhotoViewController *)viewController {
  if (viewController.index + 1 >= controllers.count) {
    return nil;
  }
  
  UIViewController* nextController = [controllers objectAtIndex:viewController.index + 1];
  return nextController;
}


@end

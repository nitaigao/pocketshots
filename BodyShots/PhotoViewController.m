#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize photoPath, creationDate, index, photo;

- (void)viewWillAppear:(BOOL)animated {
  if (photo.image == nil) {
    photo.image = [UIImage imageWithContentsOfFile:photoPath];
  }
}

@end

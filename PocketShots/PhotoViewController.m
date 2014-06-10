#import "PhotoViewController.h"

#import "PhotoAlbum.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize photo, photoPath;

- (void)viewWillAppear:(BOOL)animated {
  photo.image = [UIImage imageWithContentsOfFile:photoPath];
}

- (IBAction)trashPhoto:(id)sender {
  [PhotoAlbum deletePhoto:photoPath];
  [self.navigationController popViewControllerAnimated:YES];
}

@end

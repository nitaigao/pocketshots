#import "PhotoViewController.h"

#import "PhotoAlbum.h"
#import "NSBundle+Documents.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize photo, photoPath;

- (void)viewWillAppear:(BOOL)animated {
  photo.image = [UIImage imageWithContentsOfFile:photoPath];
}

- (IBAction)trashPhoto:(id)sender {
  PhotoAlbum* photoAlbum = [PhotoAlbum albumWithDirectory:[NSBundle mainBundle].documentsPath];
  [photoAlbum deletePhoto:photoPath];
  [self.navigationController popViewControllerAnimated:YES];
}

@end

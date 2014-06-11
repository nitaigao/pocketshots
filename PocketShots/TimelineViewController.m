#import "TimelineViewController.h"

#import "PhotoAlbum.h"

#import "TimelineCollectionViewCell.h"

#import "PhotoViewController.h"

#import "NSBundle+Documents.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

@synthesize photosCollectionView;

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    photoAlbum = [PhotoAlbum albumWithDirectory:[NSBundle mainBundle].documentsPath];
  }
  return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return photoAlbum.photoCount;
}

- (void)viewDidLoad {
  UIViewController* emptyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmptyViewController"];
  [self addChildViewController:emptyViewController];
  photosCollectionView.emptyState_view = emptyViewController.view;

  [self.navigationController.toolbar setBackgroundImage:[UIImage new]
                forToolbarPosition:UIBarPositionAny
                        barMetrics:UIBarMetricsDefault];
 
  [self.navigationController.toolbar setShadowImage:[UIImage new]
            forToolbarPosition:UIToolbarPositionAny];
}

- (void)viewWillAppear:(BOOL)animated {
  [photoAlbum loadPhotos];
  [photosCollectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TimelineCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectonViewCell" forIndexPath:indexPath];
  
  NSString* photoPath = [photoAlbum photoAtIndex:indexPath.row];
  cell.photo.image = [UIImage imageWithContentsOfFile:photoPath];
  cell.photoPath = photoPath;
  
  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  BOOL isDetailSegue = [segue.identifier isEqualToString:@"detail"];
  if (isDetailSegue) {
    TimelineCollectionViewCell* timeLineCollectionViewCell = sender;
    PhotoViewController* photoViewController = segue.destinationViewController;
    [photoViewController setPhotoPath:timeLineCollectionViewCell.photoPath];
  }
}

@end

#import "TimelineViewController.h"

#import "PhotoAlbum.h"

#import "TimelineCollectionViewCell.h"

#import "PhotoViewController.h"

#import "NSBundle+Documents.h"

#import "Photo.h"

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

- (void)viewDidAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [self.navigationController setToolbarHidden:NO animated:animated];

  photosCollectionView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [photoAlbum loadPhotos];
  [photosCollectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  photosCollectionView.delegate = nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TimelineCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectonViewCell" forIndexPath:indexPath];
  
  Photo* photo = [photoAlbum photoAtIndex:indexPath.row];
  cell.photo.image = [UIImage imageWithContentsOfFile:photo.path];
  cell.photoPath = photo.path;
  cell.date.text = photo.shortDate;
  
  [cell.layer setMasksToBounds    :NO];
  [cell.layer setShadowColor      :[[UIColor blackColor ] CGColor]];
  [cell.layer setShadowOpacity    :0.65];
  [cell.layer setShadowRadius     :1.0];
  [cell.layer setShadowOffset     :CGSizeMake( 0 , 0 )];
  [cell.layer setShouldRasterize  :YES];
  [cell.layer setShadowPath       :[[UIBezierPath bezierPathWithRect:cell.bounds ] CGPath ]];
  
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
  
  if(translation.y > 0) {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
  } else {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
  }
}

@end

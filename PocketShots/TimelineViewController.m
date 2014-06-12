#import "TimelineViewController.h"

#import "PhotoAlbum.h"

#import "TimelineCollectionViewCell.h"

#import "PhotoViewController.h"

#import "NSBundle+Documents.h"

#import "Photo.h"

#import "QuartzCore/CALayer.h"

#import "PhotoDeleteActionSheetDelegate.h"

@interface UIBarButtonItem(MyCategory)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;

@end

@implementation UIBarButtonItem(MyCategory)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  
  button.frame = CGRectMake(0.0, 00.0, image.size.width, image.size.height);
  [button setBackgroundImage:image forState:UIControlStateNormal];
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  
  UIView* view = [[UIView alloc] initWithFrame:button.frame];
  [view addSubview:button];
  
  UIBarButtonItem* forward = [[UIBarButtonItem alloc] initWithCustomView:view];
  return forward;
}

@end

@interface TimelineViewController ()

@end

@implementation TimelineViewController

@synthesize photosCollectionView;

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    photoAlbum = [PhotoAlbum albumWithDirectory:[NSBundle mainBundle].documentsPath];
  }
  return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return photoAlbum.photoCount;
}

- (void)newPhoto {
  [self performSegueWithIdentifier:@"photo" sender:self];
}

- (void)viewDidLoad {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
  UIViewController* emptyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmptyViewController"];
  [self addChildViewController:emptyViewController];
  photosCollectionView.emptyState_view = emptyViewController.view;
  
  self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:40/255.0 alpha:1.0f];
  self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:40/255.0 alpha:1.0f];
 
  
  UIImage *buttonImage = [UIImage imageNamed:@"button-camera.png"];
  UIBarButtonItem* cameraButtonItem = [UIBarButtonItem barItemWithImage:buttonImage target:self action:@selector(newPhoto)];
  UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  [self setToolbarItems:[NSArray arrayWithObjects:left, cameraButtonItem, right, nil] animated:YES];
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
  
  self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor],NSForegroundColorAttributeName,
                                  [UIColor whiteColor],NSBackgroundColorAttributeName,
                                  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:21.0], NSFontAttributeName,
                                  nil];
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
  
  cell.date.attributedText = photo.formattedDate;
  
  UIGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
  panGestureRecognizer.delegate = self;
  [cell addGestureRecognizer:panGestureRecognizer];
  
  [collectionView.panGestureRecognizer requireGestureRecognizerToFail:panGestureRecognizer];
  
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
  
  float scrollOffset = scrollView.contentOffset.y;
  if (scrollOffset <= 0) {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    return;
  }

  CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];

  if (translation.y > 0) {
    if (translation.y > 150) {
      [self.navigationController setNavigationBarHidden:NO animated:YES];
      [self.navigationController setToolbarHidden:NO animated:YES];
    }
  } else {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    
    TimelineCollectionViewCell* viewCell = (TimelineCollectionViewCell*)[photosCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:actionSheet.tag inSection:0]];
    [UIView animateWithDuration:0.2
                     animations:^{viewCell.frame = viewCell.initialFrame; }
                     completion: nil];
  }
  
  if (buttonIndex == 0) {
    TimelineCollectionViewCell* viewCell = (TimelineCollectionViewCell*)[photosCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:actionSheet.tag inSection:0]];
    [photoAlbum deletePhoto:viewCell.photoPath];
    NSIndexPath* indexPath = [photosCollectionView indexPathForCell:viewCell];
    [photosCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
  }
}

- (void)removeCell:(TimelineCollectionViewCell*)cell {
  UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete?"
                                                           delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Delete"
                                                  otherButtonTitles:nil];
  
  actionSheet.tag = [photosCollectionView indexPathForCell:cell].row;
  [actionSheet showInView:self.view];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
  CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
  return (translation.y * translation.y < translation.x * translation.x);
}

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer {
  
  if (panRecognizer.state == UIGestureRecognizerStateBegan) {
    TimelineCollectionViewCell* viewCell =  (TimelineCollectionViewCell*)panRecognizer.view;
    viewCell.initialFrame = viewCell.frame;
  }
  
  if (panRecognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [panRecognizer translationInView:panRecognizer.view];
    CGPoint imageViewPosition = panRecognizer.view.center;
    imageViewPosition.x += translation.x;
    if (imageViewPosition.x <= 160) {
      panRecognizer.view.center = imageViewPosition;
      [panRecognizer setTranslation:CGPointZero inView:panRecognizer.view];
    }
  }
  
  if (panRecognizer.state == UIGestureRecognizerStateEnded) {
    if (panRecognizer.view.center.x < 50) {
      [UIView animateWithDuration:0.4
                       animations:^{panRecognizer.view.frame = CGRectMake(panRecognizer.view.frame.origin.x - 1000, panRecognizer.view.frame.origin.y, panRecognizer.view.frame.size.width, panRecognizer.view.frame.size.height);}
                       completion:^(BOOL finished) {
                         TimelineCollectionViewCell* viewCell =  (TimelineCollectionViewCell*)panRecognizer.view;
                         [self removeCell:viewCell];
                       }];
    } else {
      TimelineCollectionViewCell* viewCell =  (TimelineCollectionViewCell*)panRecognizer.view;
      [UIView animateWithDuration:0.2
                       animations:^{panRecognizer.view.frame = viewCell.initialFrame; }
                       completion: nil];
    }
  }
}

@end

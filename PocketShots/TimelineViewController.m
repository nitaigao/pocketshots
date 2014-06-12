#import "TimelineViewController.h"

#import "PhotoAlbum.h"

#import "TimelineCollectionViewCell.h"

#import "PhotoViewController.h"

#import "NSBundle+Documents.h"

#import "Photo.h"

#import "QuartzCore/CALayer.h"

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
  
  NSString* shortDate = photo.shortDate;
  NSRange range = [shortDate rangeOfString:@" "];
  NSInteger suffixIndex = range.location - 2;
  
  NSMutableAttributedString *formattedDate = [[NSMutableAttributedString alloc] initWithString:photo.shortDate];

  [formattedDate addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:28.0]
                        range:NSMakeRange(0, suffixIndex)];

  [formattedDate addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:16.0]
                        range:NSMakeRange(suffixIndex, 2)];
  
  [formattedDate addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:21.0]
                        range:NSMakeRange(range.location, photo.shortDate.length - range.location)];
  
  cell.date.attributedText = formattedDate;
  
//  [cell.layer setMasksToBounds    :NO];
//  [cell.layer setShadowColor      :[[UIColor blackColor ] CGColor]];
//  [cell.layer setShadowOpacity    :0.65];
//  [cell.layer setShadowRadius     :1.0];
//  [cell.layer setShadowOffset     :CGSizeMake( 0 , 0 )];
//  [cell.layer setShouldRasterize  :YES];
//  [cell.layer setShadowPath       :[[UIBezierPath bezierPathWithRect:cell.bounds ] CGPath ]];

//  [cell.layer setMasksToBounds    :NO];

//  [cell.photoContainer.layer setMasksToBounds    :NO];
//  [cell.photoContainer.layer setShadowColor      :[[UIColor blackColor ] CGColor]];
//  [cell.photoContainer.layer setShadowOpacity    :0.65];
//  [cell.photoContainer.layer setShadowRadius     :0.5];
//  [cell.photoContainer.layer setShadowOffset     :CGSizeMake( 0 , 0 )];
//  [cell.photoContainer.layer setShouldRasterize  :YES];
//  [cell.photoContainer.layer setShadowPath       :[[UIBezierPath bezierPathWithRect:cell.photoContainer.bounds ] CGPath ]];

//  [cell.statsContainer.layer setMasksToBounds    :NO];
//  [cell.statsContainer.layer setShadowColor      :[[UIColor blackColor ] CGColor]];
//  [cell.statsContainer.layer setShadowOpacity    :0.65];
//  [cell.statsContainer.layer setShadowRadius     :0.5];
//  [cell.statsContainer.layer setShadowOffset     :CGSizeMake( 0 , 0 )];
//  [cell.statsContainer.layer setShouldRasterize  :YES];
//  [cell.statsContainer.layer setShadowPath       :[[UIBezierPath bezierPathWithRect:cell.statsContainer.bounds ] CGPath ]];

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
  
  if (translation.y > 0) {
    if (translation.y > 175) {
      [self.navigationController setNavigationBarHidden:NO animated:YES];
      [self.navigationController setToolbarHidden:NO animated:YES];
    }
  } else {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
  }
}

@end

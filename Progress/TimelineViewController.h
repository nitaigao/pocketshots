#import <UIKit/UIKit.h>

#import "UICollectionView+EmptyState.h"

#import "PhotoAlbum.h"

@class TimelineCollectionViewCell;

@interface TimelineViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewEmptyStateDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate> {
  PhotoAlbum* photoAlbum;
  NSInteger cellsLoaded;
  UIViewController* emptyViewController;
}

@property (nonatomic, retain) IBOutlet UICollectionView* photosCollectionView;

- (void)deletePhotoCell:(TimelineCollectionViewCell*)cell;
- (void)resetCellsLoaded;

@end

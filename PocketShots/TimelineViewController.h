#import <UIKit/UIKit.h>

#import "UICollectionView+EmptyState.h"

#import "PhotoAlbum.h"

@class TimelineCollectionViewCell;

@interface TimelineViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewEmptyStateDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate> {
  PhotoAlbum* photoAlbum;
}

@property (nonatomic, retain) IBOutlet UICollectionView* photosCollectionView;

- (void)deletePhotoCell:(TimelineCollectionViewCell*)cell;

@end

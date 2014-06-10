#import <UIKit/UIKit.h>

#import "UICollectionView+EmptyState.h"

#import "PhotoAlbum.h"

@interface TimelineViewController : UIViewController<UICollectionViewDataSource, UICollectionViewEmptyStateDelegate> {
  PhotoAlbum* photoAlbum;
}

@property (nonatomic, retain) IBOutlet UICollectionView* photosCollectionView;

@end

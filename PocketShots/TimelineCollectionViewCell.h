#import <UIKit/UIKit.h>

@class TimelineViewController;
@class TimelineCollectionViewCellContentContainer;

@interface TimelineCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView* photo;
@property (nonatomic, strong) IBOutlet UIView* photoContainer;
@property (nonatomic, strong) IBOutlet UIView* statsContainer;

@property (nonatomic, strong) IBOutlet TimelineCollectionViewCellContentContainer* contentContainer;

@property (nonatomic, weak) IBOutlet UILabel* date;
@property (nonatomic, strong) NSString* photoPath;

@property (nonatomic, weak) TimelineViewController* timelineViewController;

- (void)setPhotoImage:(NSString*)photoPath;

@end

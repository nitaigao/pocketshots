#import <UIKit/UIKit.h>

@interface TimelineCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView* photo;
@property (nonatomic, strong) IBOutlet UIView* photoContainer;
@property (nonatomic, strong) IBOutlet UIView* statsContainer;

@property (nonatomic, weak) IBOutlet UILabel* date;
@property (nonatomic, strong) NSString* photoPath;

- (void)setPhotoImage:(NSString*)photoPath;

@end

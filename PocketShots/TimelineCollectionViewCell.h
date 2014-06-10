#import <UIKit/UIKit.h>

@interface TimelineCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView* photo;
@property (nonatomic, strong) NSString* photoPath;

- (void)setPhotoImage:(NSString*)photoPath;

@end

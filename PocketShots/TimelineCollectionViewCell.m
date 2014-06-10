#import "TimelineCollectionViewCell.h"

@implementation TimelineCollectionViewCell

@synthesize photo, photoPath;

- (void)setPhotoImage:(NSString*)photoImagePath {
  self.photoPath = photoImagePath;
  photo.image = [UIImage imageWithContentsOfFile:photoImagePath];
}

@end

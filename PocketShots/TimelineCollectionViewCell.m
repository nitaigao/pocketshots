#import "TimelineCollectionViewCell.h"

#import <QuartzCore/QuartzCore.h>

@implementation TimelineCollectionViewCell

@synthesize photo, photoContainer, statsContainer, date, photoPath;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)setPhotoImage:(NSString*)photoImagePath {
  self.photoPath = photoImagePath;
  photo.image = [UIImage imageWithContentsOfFile:photoImagePath];
}

@end

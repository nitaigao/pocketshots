#import "TimelineCollectionViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import "TimelineViewController.h"
#import "TimelineCollectionViewCellContentContainer.h"

@implementation TimelineCollectionViewCell

@synthesize photo, photoContainer, statsContainer, date, photoPath, contentContainer, timelineViewController;

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

- (IBAction)deletePhoto:(id)sender {
  [timelineViewController deletePhotoCell:self];
}

- (IBAction)cancelDelete:(id)sender {
  [UIView animateWithDuration:0.4
                   animations:^{contentContainer.frame = contentContainer.initialFrame; }
                   completion: nil];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.contentContainer.frame = self.contentContainer.initialFrame;
}

@end

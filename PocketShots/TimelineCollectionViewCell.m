#import "TimelineCollectionViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import "TimelineViewController.h"

@implementation TimelineCollectionViewCell

@synthesize photo, photoContainer, statsContainer, date, photoPath, contentContainer, timelineViewController, initialFrame;

- (void)setPhotoImage:(NSString*)photoImagePath {
  self.photoPath = photoImagePath;
  photo.image = [UIImage imageWithContentsOfFile:photoImagePath];
}

- (IBAction)deletePhoto:(id)sender {
  [timelineViewController deletePhotoCell:self];
}

//- (void)prepareForReuse {
//  [super prepareForReuse];
////  self.frame = self.initialFrame;
//}

@end

#import <UIKit/UIKit.h>

@interface ImportProcessingPhotosViewController : UIViewController {
  NSMutableArray* photosToProcess;
}

@property (nonatomic, weak) IBOutlet UIProgressView* progressBar;

- (void)addPhotosToProcess:(NSArray*)photos;

@end

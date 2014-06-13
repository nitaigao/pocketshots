#import <UIKit/UIKit.h>

@interface NoPhotosViewController : UIViewController {
  BOOL animating;
}

@property (nonatomic, weak) IBOutlet UIView* welcomeView;
@property (nonatomic, weak) IBOutlet UIImageView* downArrow;

@end

#import <UIKit/UIKit.h>

@interface NoPhotosViewController : UIViewController

@property (nonatomic, readwrite) NSInteger index;

- (void)purge;

@end

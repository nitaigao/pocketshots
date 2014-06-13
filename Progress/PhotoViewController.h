#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView* photo;
@property (nonatomic, strong) NSString* photoPath;

@end

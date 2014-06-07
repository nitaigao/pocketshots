#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) NSString* photoPath;
@property (nonatomic, strong) NSDate* creationDate;
@property (nonatomic, readwrite) NSInteger index;

@property (nonatomic, weak) IBOutlet UIImageView* photo;

@end

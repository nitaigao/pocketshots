#import <UIKit/UIKit.h>

#import <QBImagePickerController/QBImagePickerController.h>

@interface ImportSelectPhotosViewController : UIViewController<QBImagePickerControllerDelegate> {
  NSMutableArray* photosToImport;
  UINavigationController *navigationController;
}

@end

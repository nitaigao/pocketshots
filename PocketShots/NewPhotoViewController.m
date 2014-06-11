#import "NewPhotoViewController.h"

#import "PhotoAlbum.h"
#import "NSBundle+Documents.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface NewPhotoViewController ()

@end

@implementation NewPhotoViewController

- (void)viewDidLoad {
  UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
//#ifndef TARGET_IPHONE_SIMULATOR
  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//#endif  
  imagePickerController.delegate = self;
  [self addChildViewController:imagePickerController];
  [self.view addSubview:imagePickerController.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
  
  PhotoAlbum* photoAlbum = [PhotoAlbum albumWithDirectory:[NSBundle mainBundle].documentsPath];

  NSDate* captureDate = [NSDate date];
  [photoAlbum savePhoto:image forDate:captureDate];
  
//  NSData* jpegData = UIImageJPEGRepresentation(image, 1.0f);
//  NSDate *digitizedDate = [NSDate date];
//
//  CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)jpegData, NULL);
//  CFDictionaryRef metadata = CGImageSourceCopyPropertiesAtIndex(sourceRef, 0, NULL);
//  if (NULL != metadata) {
//
//    CFDictionaryRef exifData = CFDictionaryGetValue(metadata, kCGImagePropertyExifDictionary);
//    if (NULL != exifData) {
//
//      NSDictionary* dic = (__bridge NSDictionary*)metadata;
//      NSLog(@"%@", dic);
//      CFStringRef digitizedDateRaw = CFDictionaryGetValue(exifData, kCGImagePropertyExifDateTimeDigitized);
//      NSString* digitizedDateString = (__bridge NSString*)digitizedDateRaw;
//
//      if (digitizedDateString) {
//        NSLog(@"%@", digitizedDateString);
////        digitizedDate = [NSDate dateFromExifString:digitizedDateString];
//      }
//    }
//
//    CFRelease(metadata);
//  }

  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
}


@end

#import "PhotoAlbum.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "NSArray+Functional.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface NSBundle(Documents)

- (NSString *) documentsPath;

@end

@implementation NSBundle(Documents)

- (NSString *) documentsPath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  return basePath;
}

@end

@interface PhotoAlbum(Private)

+ (NSArray*) photos;

@end

@implementation PhotoAlbum

+ (void)iterateImages:(void (^)(NSString*, NSDate*, NSInteger, NSInteger))iterator {
  [self.photos enumerateObjectsUsingBlock:^(NSString* filepath, NSUInteger idx, BOOL *stop) {
    NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
    NSDate* creationDate = [attrs objectForKey:NSFileCreationDate];
    iterator(filepath, creationDate, idx, self.photos.count);
  }];
}

+ (NSInteger)photoCount {
  return self.photos.count;
}

+ (void)purgeAlbum {
  for (NSString* photoPath in [self photos]) {
    [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
  }
}

+ (NSArray*)photos {
  NSArray* directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSBundle mainBundle].documentsPath error:nil];
  NSPredicate* filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.JPG'"];
  NSArray* jpgFiles = [directoryContents filteredArrayUsingPredicate:filter];
  NSMutableArray* photoPaths = [NSMutableArray array];
  
  for (NSString* filename in jpgFiles) {
    NSString* photoPath = [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].documentsPath, filename];
    [photoPaths addObject:photoPath];
  }
  
  return photoPaths;
}

+ (NSString*)uniqueFileName {
  CFUUIDRef uuid = CFUUIDCreate(NULL);
  CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
  CFRelease(uuid);
  NSString *uniqueFileName = [NSString stringWithFormat:@"%@", (__bridge NSString*)uuidString];
  CFRelease(uuidString);
  return uniqueFileName;
}

+ (NSString*)uniquePhotoPath {
  return [NSString stringWithFormat:@"%@/%@.JPG", [NSBundle mainBundle].documentsPath, [self uniqueFileName]];
}

+ (void)savePhoto:(UIImage*)photo {
  NSString* photoPath = [self uniquePhotoPath];
  [UIImageJPEGRepresentation(photo, 1.0f) writeToFile:photoPath atomically:YES];
}

+ (void)deletePhoto:(NSString*)photoPath {
  [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
}

+ (void)importPhotosRecursive:(NSArray*)photosURLs index:(NSInteger)index progress:(void(^)(float percent))progress complete:(void(^)())complete {
  progress((index + 1) / (float)photosURLs.count);
  
  // Exit
  if (index + 1 == photosURLs.count) {
    complete();
    return;
  }
  
  //Work
  ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
  NSURL* photoURL = [photosURLs objectAtIndex:index];
  [assetLibrary assetForURL:photoURL resultBlock:^(ALAsset *asset) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:[self uniquePhotoPath]];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypeJPEG, 1, NULL);
    CGImageDestinationAddImage(destination, asset.defaultRepresentation.fullResolutionImage, nil);
    CGImageDestinationFinalize(destination);

    // Next
    [self importPhotosRecursive:photosURLs index:index + 1 progress:progress complete:complete];
  } failureBlock:^(NSError *error) {
    NSLog(@"%@", error);
  }];
}

+ (void)importPhotos:(NSArray *)photoURLs progress:(void(^)(float percent))progress complete:(void(^)())complete {
  [self importPhotosRecursive:photoURLs index:0 progress:progress complete:complete];
}

@end

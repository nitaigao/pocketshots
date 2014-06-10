#import "PhotoAlbum.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "NSArray+Functional.h"
#import "NSDate+DateFromString.h"
#import <NSArray+F.h>
#import "NSFileManager+Filename.h"
#import "NSBundle+Documents.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "Exif.h"

@interface PhotoAlbum(Private)

@end

@implementation PhotoAlbum

- (instancetype)initWithDirectory:(NSString*)aDirectoryPath {
  self = [super init];
  if (self) {
    photos = [NSArray array];
    directoryPath = [NSString stringWithString:aDirectoryPath];
  }
  return self;
}

- (NSArray*)jpgFiles {
  NSArray* directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
  NSPredicate* filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.JPG'"];
  NSArray* jpgFiles = [directoryContents filteredArrayUsingPredicate:filter];
  return jpgFiles;
}

- (void)loadPhotos {
  NSArray* jpgFiles = [self jpgFiles];
  
  NSArray* photoPaths = [jpgFiles map:^id(NSString* filename) {
    NSString* photoPath = [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].documentsPath, filename];
    return photoPath;
  }];

  photos = [[[photoPaths sortedArrayUsingComparator:^NSComparisonResult(NSString* photoA, NSString* photoB) {
    Exif* exifA = [[Exif alloc] initWithFile:photoA];
    Exif* exifB = [[Exif alloc] initWithFile:photoB];
    
    NSComparisonResult comparisonResult = [exifA.digitizedDate compare:exifB.digitizedDate];
    return comparisonResult;
  }] reverseObjectEnumerator] allObjects];
}

- (NSString*)photoAtIndex:(NSInteger)index {
  return [photos objectAtIndex:index];
}

- (NSInteger)photoCount {
  return photos.count;
}

- (void)purge {
  for (NSString* photoPath in photos) {
    [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
  }
}

+ (NSString*)uniquePhotoPath {
  return [NSString stringWithFormat:@"%@/%@.JPG", [NSBundle mainBundle].documentsPath, [NSFileManager uniqueFileName]];
}

+ (void)savePhoto:(UIImage*)photo {
  NSString* photoPath = [self uniquePhotoPath];
  [UIImageJPEGRepresentation(photo, 1.0f) writeToFile:photoPath atomically:YES];
}

+ (void)deletePhoto:(NSString*)photoPath {
  [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
}

+ (void)importPhotos:(NSArray *)photoURLs progress:(void(^)(float percent))progress complete:(void(^)())complete {
  [self importPhotosRecursive:photoURLs index:0 progress:progress complete:complete];
}

+ (void)importPhotosRecursive:(NSArray*)photosURLs index:(NSInteger)index progress:(void(^)(float percent))progress complete:(void(^)())complete {
  // Exit
  if (index == photosURLs.count) {
    complete();
    return;
  }
  
  progress((index + 1) / (float)photosURLs.count);
  
  //Work
  ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
  NSURL* photoURL = [photosURLs objectAtIndex:index];
  [assetLibrary assetForURL:photoURL resultBlock:^(ALAsset *asset) {
    
    Byte *buffer = (Byte*)malloc(asset.defaultRepresentation.size);
    NSInteger length = [asset.defaultRepresentation getBytes:buffer
                                                  fromOffset: 0.0
                                                      length:asset.defaultRepresentation.size
                                                       error:nil];
    
    NSData *rawData = [NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:YES];
    [rawData writeToFile:[self uniquePhotoPath] atomically:YES];

    // Next
    [self importPhotosRecursive:photosURLs index:index + 1 progress:progress complete:complete];
  } failureBlock:^(NSError *error) {
    NSLog(@"%@", error);
  }];
}

@end

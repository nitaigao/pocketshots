#import "PhotoAlbum.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "NSDate+DateFromString.h"
#import <NSArray+F.h>
#import "NSFileManager+Filename.h"
#import "NSBundle+Documents.h"

#import "Photo.h"

@interface PhotoAlbum(Private)

@end

@implementation PhotoAlbum

+ (NSString*)uniquePhotoPath {
  return [NSString stringWithFormat:@"%@/%@.JPG", [NSBundle mainBundle].documentsPath, [NSFileManager uniqueFileName]];
}

- (instancetype)initWithDirectory:(NSString*)aDirectoryPath {
  self = [super init];
  if (self) {
    photos = [NSMutableArray array];
    directoryPath = [NSString stringWithString:aDirectoryPath];
  }
  return self;
}

+ (instancetype)albumWithDirectory:(NSString*)directoryPath {
  PhotoAlbum* photoAlbum = [[PhotoAlbum alloc] initWithDirectory:directoryPath];
  [photoAlbum loadPhotos];
  return photoAlbum;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
  return [photos countByEnumeratingWithState:state objects:buffer count:len];
}

- (void)saveMetaData {
  NSString* metaDataPath = [NSString stringWithFormat:@"%@/metadata.plist", directoryPath];
  [photos writeToFile:metaDataPath atomically:YES];
}

- (void)loadPhotos {
  NSString* metaDataPath = [NSString stringWithFormat:@"%@/metadata.plist", directoryPath];
  NSArray* loadedPhotos = [NSArray arrayWithContentsOfFile:metaDataPath];
  
  [photos removeAllObjects];
  
  NSArray* sortedPhotos = [loadedPhotos sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* a, NSDictionary* b) {
    NSComparisonResult comparisonResult = [[a objectForKey:@"date"] compare:[b objectForKey:@"date"]];
    return comparisonResult;
  }];
  
  NSArray* reversedPhotos = [[sortedPhotos reverseObjectEnumerator] allObjects];
  
  photos = [NSMutableArray arrayWithArray:reversedPhotos];
}

- (Photo*)photoAtIndex:(NSInteger)index {
  NSDictionary* photoData = [photos objectAtIndex:index];
  Photo* photo = [[Photo alloc] init];
  photo.path = [photoData objectForKey:@"path"];
  photo.date = [photoData objectForKey:@"date"];
  return photo;
}

- (NSInteger)photoCount {
  return photos.count;
}

- (void)deletePhoto:(NSString*)photoPath {
  NSArray* toDelete = [photos filter:^BOOL(NSDictionary* element) {
    return [[element objectForKey:@"path"] isEqualToString:photoPath];
  }];
  
  [toDelete enumerateObjectsUsingBlock:^(NSDictionary* element, NSUInteger index, BOOL *stop) {
    NSString* photoPath = [element objectForKey:@"path"];
    [photos removeObject:element];
    [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
  }];
  
  [self saveMetaData];
}

- (void)importPhotos:(NSArray *)photoURLs progress:(void(^)(float percent))progress complete:(void(^)())complete {
  [self importPhotosRecursive:photoURLs index:0 progress:progress complete:complete];
}

- (void)importPhotosRecursive:(NSArray*)photosURLs index:(NSInteger)index progress:(void(^)(float percent))progress complete:(void(^)())complete {
  // Exit
  if (index == photosURLs.count) {
    [self saveMetaData];
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
    
    NSString* photoPath = [PhotoAlbum uniquePhotoPath];
    NSData *rawData = [NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:YES];
    [rawData writeToFile:photoPath atomically:YES];
    
    NSDate* creationDate = (NSDate*)[asset valueForProperty:ALAssetPropertyDate];
    [photos addObject:@{@"path":photoPath, @"date": creationDate}];
    
    // Next
    [self importPhotosRecursive:photosURLs index:index + 1 progress:progress complete:complete];
  } failureBlock:^(NSError *error) {
    NSLog(@"%@", error);
  }];
}

- (void)savePhoto:(UIImage*)photo forDate:(NSDate*)date {
  NSString* photoPath = [PhotoAlbum uniquePhotoPath];
  NSData* jpegData = UIImageJPEGRepresentation(photo, 1.0f);
  [jpegData writeToFile:photoPath atomically:YES];
  [photos addObject:@{@"path":photoPath, @"date": date}];
  [self saveMetaData];
  
  ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
  [assetLibrary writeImageDataToSavedPhotosAlbum:jpegData metadata:nil completionBlock:nil];
}

@end

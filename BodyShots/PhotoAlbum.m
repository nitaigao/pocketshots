#import "PhotoAlbum.h"

#import <AssetsLibrary/AssetsLibrary.h>

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

+ (void)importPhoto:(NSURL *)photoURL complete:(void (^)())complete {
  ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
  [assetLibrary assetForURL:photoURL resultBlock:^(ALAsset *asset) {
    UIImage *currentImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
    NSData *currentImageData = UIImagePNGRepresentation(currentImage);
    NSString* photoPath = [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].documentsPath, asset.defaultRepresentation.filename];
    [currentImageData writeToFile:photoPath atomically:YES];
    complete();
  } failureBlock:^(NSError *error) {
    NSLog(@"%@", error);
  }];
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


@end

#import <Foundation/Foundation.h>

@class ALAssetsLibrary;
@class Photo;

@interface PhotoAlbum : NSObject<NSFastEnumeration> {
  NSString* directoryPath;
  NSMutableArray* photos;
}

- (instancetype)initWithDirectory:(NSString*)directoryPath;

+ (instancetype)albumWithDirectory:(NSString*)directoryPath;

- (void)loadPhotos;

- (NSInteger)photoCount;

- (Photo*)photoAtIndex:(NSInteger)index;

- (void)deletePhoto:(NSString*)photoPath;

- (void)importPhotos:(NSArray*)photoURLs progress:(void(^)(float))progress complete:(void(^)())complete;

- (void)savePhoto:(UIImage*)photo forDate:(NSDate*)date;

@end

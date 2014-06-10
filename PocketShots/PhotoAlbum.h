#import <Foundation/Foundation.h>

@class ALAssetsLibrary;

@interface PhotoAlbum : NSObject {
  NSString* directoryPath;
  NSArray* photos;
}

- (instancetype)initWithDirectory:(NSString*)directoryPath;

// Context Specific

- (void)loadPhotos;

- (NSInteger)photoCount;

- (NSString*)photoAtIndex:(NSInteger)index;

- (void)purge;

// Generic External

+ (void)savePhoto:(UIImage*)photo;

+ (void)deletePhoto:(NSString*)photoPath;

+ (void)importPhotos:(NSArray*)photoURLs progress:(void(^)(float))progress complete:(void(^)())complete;

@end

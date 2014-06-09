#import <Foundation/Foundation.h>

@class ALAssetsLibrary;

@interface PhotoAlbum : NSObject

+ (NSInteger)photoCount;

+ (void)purgeAlbum;

+ (void)savePhoto:(UIImage*)photo;

+ (void)deletePhoto:(NSString*)photoPath;

+ (void)importPhotos:(NSArray*)photoURLs progress:(void(^)(float))progress complete:(void(^)())complete;

+ (void)iterateImages:(void (^)(NSString*, NSDate*, NSInteger, NSInteger))iterator;

@end

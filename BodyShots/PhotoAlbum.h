#import <Foundation/Foundation.h>

@interface PhotoAlbum : NSObject

+ (NSInteger)photoCount;

+ (void)purgeAlbum;

+ (void)savePhoto:(UIImage*)photo;

+ (void)deletePhoto:(NSString*)photoPath;

+ (void)importPhoto:(NSURL*)photoURL complete:(void (^)())complete index:(NSInteger)index;

+ (void)importPhotos:(NSArray*)photoURLs progress:(void(^)(float))progress complete:(void(^)())complete;

+ (void)iterateImages:(void (^)(NSString*, NSDate*, NSInteger, NSInteger))iterator;

@end

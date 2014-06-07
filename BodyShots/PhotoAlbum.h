#import <Foundation/Foundation.h>

@interface PhotoAlbum : NSObject

+ (NSInteger)photoCount;

+ (void)purgeAlbum;

+ (void)savePhoto:(UIImage*)photo;

+ (void)deletePhoto:(NSString*)photoPath;

+ (void)importPhoto:(NSURL*)photoURL complete:(void (^)())complete;

+ (void)iterateImages:(void (^)(NSString*, NSDate*, NSInteger, NSInteger))iterator;

@end

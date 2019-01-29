
#import <React/RCTViewManager.h>

@interface RNTPhotoBrowserManager : RCTViewManager

+ (void)setImageLoader:(void (^ _Null_unspecified)(UIImageView*, NSString*, void (^ _Null_unspecified)(BOOL), void (^ _Null_unspecified)(NSInteger, NSInteger), void (^ _Null_unspecified)(UIImage*)))value;

+ (void)setImageIsLoaded:(BOOL (^ _Null_unspecified)(NSString*))value;

+ (void)setImageCachePath:(NSString* (^ _Null_unspecified)(NSString*))value;

+ (void)setAlbumName:(NSString*)name;

@end


#import <React/RCTViewManager.h>

@interface RNTPhotoBrowserManager : RCTViewManager

+ (void)init:(NSString*_Nullable)name loadImage:(void (^ _Null_unspecified)(UIImageView*_Nullable, NSString*_Nullable, NSInteger, NSInteger, void (^ _Null_unspecified)(BOOL), void (^ _Null_unspecified)(NSInteger, NSInteger), void (^ _Null_unspecified)(UIImage*_Nullable)))loadImage isImageLoaded:(BOOL (^ _Null_unspecified)(NSString*_Nullable))isImageLoaded getImageCachePath:(NSString* _Nullable (^ _Null_unspecified)(NSString*_Nullable))getImageCachePath;

@end


#import <React/RCTViewManager.h>

@interface RNTPhotoBrowserManager : RCTViewManager

+ (void)setImageLoader:(void (^ _Null_unspecified)(UIImageView*_Nullable, NSString*_Nullable, NSInteger, NSInteger, void (^ _Null_unspecified)(BOOL), void (^ _Null_unspecified)(NSInteger, NSInteger), void (^ _Null_unspecified)(UIImage*_Nullable)))value;

+ (void)setImageIsLoaded:(BOOL (^ _Null_unspecified)(NSString*_Nullable))value;

+ (void)setImageCachePath:(NSString* _Nullable (^ _Null_unspecified)(NSString*_Nullable))value;

+ (void)setAlbumName:(NSString*_Nullable)name;

@end

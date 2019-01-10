
#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>

@interface RNTPhotoBrowserModule : NSObject <RCTBridgeModule>

+ (void)setImageLoader:(void (^ _Null_unspecified)(UIImageView*, NSString*, NSInteger, NSInteger, void (^ _Null_unspecified)(BOOL), void (^ _Null_unspecified)(NSInteger, NSInteger), void (^ _Null_unspecified)(UIImage*)))value;

+ (void)setImageIsLoaded:(BOOL (^ _Null_unspecified)(NSString*))value;

+ (void)setImageCachePath:(NSString* (^ _Null_unspecified)(NSString*))value;

+ (void)setAlbumName:(NSString* (^ _Null_unspecified)())value;

@end

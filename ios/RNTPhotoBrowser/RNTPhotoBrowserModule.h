
#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>

@interface RNTPhotoBrowserModule : NSObject <RCTBridgeModule>

+ (void)setImageLoader:(void (^ _Null_unspecified)(UIImageView * imageView, NSString * url, void (^ onLoadStart)(BOOL), void (^ onLoadProgress)(int64_t, int64_t), void (^ onLoadEnd)(BOOL)))value;

@end

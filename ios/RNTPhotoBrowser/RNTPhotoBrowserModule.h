
#import <Foundation/Foundation.h>

#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>

@interface RNTPhotoBrowserModule : NSObject <RCTBridgeModule>

+ (void)setLoadImage:(void (^ _Null_unspecified)(UIImageView * _Nonnull, NSString * _Nonnull, void (^ _Nonnull)(int64_t, int64_t), void (^ _Nonnull)(void)))value;

@end

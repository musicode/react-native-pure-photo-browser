
#import "RNTPhotoBrowserModule.h"
#import "RNTPhotoBrowser-Swift.h"

@implementation RNTPhotoBrowserModule

+ (void)setLoadImage:(void (^ _Null_unspecified)(UIImageView * _Nonnull, NSString * _Nonnull, void (^ _Nonnull)(int64_t, int64_t), void (^ _Nonnull)(void)))value
{
    PhotoBrowser.loadImage = value;
}

RCT_EXPORT_MODULE(RNTPhotoBrowser);

RCT_EXPORT_METHOD(openBrowser:(int)index list:(NSArray *)list) {
    PhotoBrowser.open(index, list);
}

RCT_EXPORT_METHOD(compressImage:(NSString *)src dest:(NSString *)dest callback:(RCTResponseSenderBlock)callback) {
    BOOL result = PhotoBrowser.compress(src, dest);
    if (result) {
        callback(@[
                   [NSNull null],
                    @{
                       @"path": dest
                       }
                   ]);
    }
    else {
        callback(@[@"error"]);
    }
}

@end

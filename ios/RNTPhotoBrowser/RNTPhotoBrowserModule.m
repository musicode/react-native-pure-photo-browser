
#import "RNTPhotoBrowserModule.h"
#import "RNTPhotoBrowser-Swift.h"

@implementation RNTPhotoBrowserModule

+ (void)setImageLoader:(void (^ _Null_unspecified)(UIImageView * _Nonnull, NSString * _Nonnull, void (^ _Nonnull)(BOOL), void (^ _Nonnull)(int64_t, int64_t), void (^ _Nonnull)(BOOL)))value
{
    RNTPhotoBrowser.loadImage = value;
}

RCT_EXPORT_MODULE(RNTPhotoBrowser);

RCT_EXPORT_METHOD(openBrowser:(NSArray *)list index:(int)index indicator:(NSString *)indicator pageMargin:(int)pageMargin) {
    RNTPhotoBrowser.open(list, index, indicator, pageMargin);
}

RCT_EXPORT_METHOD(compressImage:(NSString *)src dest:(NSString *)dest callback:(RCTResponseSenderBlock)callback) {
    CompressResult *result = RNTPhotoBrowser.compress(src, dest);
    if (result != nil) {
        callback(@[
                   [NSNull null],
                   @{
                       @"path": result.path,
                       @"width": [NSNumber numberWithInteger:result.width],
                       @"height": [NSNumber numberWithInteger:result.height]
                       }
                   ]);
    }
    else {
        callback(@[@"error"]);
    }
}

@end

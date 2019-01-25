
#import "RNTPhotoBrowserModule.h"
#import "RNTPhotoBrowser-Swift.h"

@implementation RNTPhotoBrowserModule

+ (void)setImageLoader:(void (^)(UIImageView *, NSString *, void (^ _Null_unspecified)(BOOL), void (^ _Null_unspecified)(NSInteger, NSInteger), void (^ _Null_unspecified)(UIImage *)))value {
    RNTPhotoBrowser.loadImage = value;
}

+ (void)setImageIsLoaded:(BOOL (^)(NSString *))value {
    RNTPhotoBrowser.isImageLoaded = value;
}

+ (void)setImageCachePath:(NSString *(^)(NSString *))value {
    RNTPhotoBrowser.getImageCachePath = value;
}

+ (void)setAlbumName:(NSString *)name {
    RNTPhotoBrowser.albumName = name;
}

RCT_EXPORT_MODULE(RNTPhotoBrowser);

RCT_EXPORT_METHOD(open:(NSArray *)list index:(int)index indicator:(NSString *)indicator pageMargin:(int)pageMargin) {
    RNTPhotoBrowser.open(list, index, indicator, pageMargin);
}

@end


#import <React/RCTUIManager.h>

#import "RNTPhotoBrowserManager.h"
#import "RNTPhotoBrowser-Swift.h"
#import "RNTPhotoBrowser.h"

@implementation RNTPhotoBrowserManager

+ (void)setImageLoader:(void (^)(UIImageView *, NSString *, NSInteger, NSInteger, void (^ _Null_unspecified)(BOOL), void (^ _Null_unspecified)(NSInteger, NSInteger), void (^ _Null_unspecified)(UIImage *)))value {
    RNTPhotoBrowserConfiguration.loadImage = value;
}

+ (void)setImageIsLoaded:(BOOL (^)(NSString *))value {
    RNTPhotoBrowserConfiguration.isImageLoaded = value;
}

+ (void)setImageCachePath:(NSString *(^)(NSString *))value {
    RNTPhotoBrowserConfiguration.getImageCachePath = value;
}

+ (void)setAlbumName:(NSString *)name {
    RNTPhotoBrowserConfiguration.albumName = name;
}

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [RNTPhotoBrowser new];
}

RCT_CUSTOM_VIEW_PROPERTY(indicator, int, RNTPhotoBrowser) {
    int value = [RCTConvert int:json];
    // 1 是 dot
    if (value == 1) {
        view.photoBrowser.indicator = 0;
    }
    // 2 是 number
    else if (value == 2) {
        view.photoBrowser.indicator = 1;
    }
    else {
        view.photoBrowser.indicator = 2;
    }
}

RCT_CUSTOM_VIEW_PROPERTY(pageMargin, int, RNTPhotoBrowser) {
    view.photoBrowser.pageMargin = [RCTConvert int:json];
}

RCT_CUSTOM_VIEW_PROPERTY(index, int, RNTPhotoBrowser) {
    view.photoBrowser.index = [RCTConvert int:json];
}

RCT_CUSTOM_VIEW_PROPERTY(list, NSArray, RNTPhotoBrowser) {
    
    NSMutableArray *photos = @[].mutableCopy;
    
    NSArray *list = [RCTConvert NSArray:json];
    
    for (NSDictionary *item in list) {
        
        NSString *thumbnailUrl = [RCTConvert NSString:item[@"thumbnailUrl"]];
        NSString *highQualityUrl = [RCTConvert NSString:item[@"highQualityUrl"]];
        NSString *rawUrl = [RCTConvert NSString:item[@"rawUrl"]];
        
        Photo *photo = [[Photo alloc] initWithThumbnailUrl:thumbnailUrl highQualityUrl:highQualityUrl rawUrl:rawUrl];
        
        [photos addObject:photo];
        
    }

    view.photoBrowser.photos = photos;
    
}

RCT_EXPORT_METHOD(save:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTPhotoBrowser *view = (RNTPhotoBrowser *)viewRegistry[reactTag];
        [view.photoBrowser saveImage];
    }];
}

RCT_EXPORT_METHOD(detect:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTPhotoBrowser *view = (RNTPhotoBrowser *)viewRegistry[reactTag];
        [view.photoBrowser detectQRCodeWithCallback:^(NSString *text) {
            view.onDetectComplete(@{
                                  @"text": text
                                  });
        }];
        
    }];
}

RCT_EXPORT_VIEW_PROPERTY(onTap, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLongPress, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onSaveComplete, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onDetectComplete, RCTBubblingEventBlock);

@end


#import "RNTThumbnailViewManager.h"
#import "RNTPhotoBrowser-Swift.h"
#import "RNTThumbnailView.h"

@implementation RNTThumbnailViewManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [RNTThumbnailView new];
}

RCT_CUSTOM_VIEW_PROPERTY(uri, NSString, RNTThumbnailView) {
    NSString *value = [RCTConvert NSString:json];
    [view loadImage:value];
}

RCT_CUSTOM_VIEW_PROPERTY(borderRadius, int, RNTThumbnailView) {
    int value = [RCTConvert int:json];
    view.imageView.layer.cornerRadius = value;
    if (value > 0) {
        view.imageView.clipsToBounds = YES;
    } else {
        view.imageView.clipsToBounds = NO;
    }
}

RCT_EXPORT_VIEW_PROPERTY(onThumbnailLoadStart, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onThumbnailLoadProgress, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onThumbnailLoadEnd, RCTBubblingEventBlock);

@end


#import "RNTThumbnailViewManager.h"
#import "RNTPhotoBrowser-Swift.h"
#import "RNTThumbnailView.h"

@implementation RNTThumbnailViewManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [RNTThumbnailView new];
}

RCT_CUSTOM_VIEW_PROPERTY(borderRadius, int, RNTThumbnailView) {
    view.imageView.layer.cornerRadius = [RCTConvert int:json];
}

RCT_CUSTOM_VIEW_PROPERTY(uri, NSString, RNTThumbnailView) {
    view.url = [RCTConvert NSString:json];
    [view refreshIfNeeded];
}

RCT_CUSTOM_VIEW_PROPERTY(width, int, RNTThumbnailView) {
    view.width = [RCTConvert int:json];
    [view refreshIfNeeded];
}

RCT_CUSTOM_VIEW_PROPERTY(height, int, RNTThumbnailView) {
    view.height = [RCTConvert int:json];
    [view refreshIfNeeded];
}

RCT_EXPORT_VIEW_PROPERTY(onThumbnailLoadStart, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onThumbnailLoadProgress, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onThumbnailLoadEnd, RCTBubblingEventBlock);

@end

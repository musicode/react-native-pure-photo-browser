
#import "RNTPhotoBrowser.h"
#import "react_native_pure_photo_browser-Swift.h"

@interface RNTPhotoBrowser()<PhotoBrowserDelegate>

@end

@implementation RNTPhotoBrowser

- (instancetype)init {
    self = [super init];
    if (self) {
        PhotoBrowser *view = [[PhotoBrowser alloc] initWithConfiguration:[RNTPhotoBrowserConfiguration new]];
        view.delegate = self;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:view];
        self.photoBrowser = view;
    }
    return self;
}

- (void)photoBrowserDidTapWithPhoto:(Photo *)photo index:(NSInteger)index {
    self.onTap(@{
                 @"index": @(index),
                 @"photo": @{
                         @"thumbnailUrl": photo.thumbnailUrl,
                         @"hightQualityUrl": photo.highQualityUrl,
                         @"rawQualityUrl": photo.rawUrl,
                         @"currentUrl": photo.currentUrl,
                         }
                 });
}

- (void)photoBrowserDidLongPressWithPhoto:(Photo *)photo index:(NSInteger)index {
    self.onLongPress(@{
                       @"index": @(index),
                       @"photo": @{
                               @"thumbnailUrl": photo.thumbnailUrl,
                               @"hightQualityUrl": photo.highQualityUrl,
                               @"rawQualityUrl": photo.rawUrl,
                               @"currentUrl": photo.currentUrl,
                               @"currentPath": RNTPhotoBrowserConfiguration.getImageCachePath(photo.currentUrl)
                               }
                       });
}

- (void)photoBrowserDidSavePressWithPhoto:(Photo *)photo index:(NSInteger)index {
    self.onSavePress(@{
                        @"index": @(index),
                        @"photo": @{
                                @"thumbnailUrl": photo.thumbnailUrl,
                                @"hightQualityUrl": photo.highQualityUrl,
                                @"rawQualityUrl": photo.rawUrl,
                                @"currentUrl": photo.currentUrl,
                                @"currentPath": RNTPhotoBrowserConfiguration.getImageCachePath(photo.currentUrl)
                                }
                        });
}

- (void)photoBrowserDidSaveWithPhoto:(Photo *)photo index:(NSInteger)index success:(BOOL)success {
    self.onSaveComplete(@{
                  @"index": @(index),
                  @"photo": @{
                          @"thumbnailUrl": photo.thumbnailUrl,
                          @"hightQualityUrl": photo.highQualityUrl,
                          @"rawQualityUrl": photo.rawUrl,
                          @"currentUrl": photo.currentUrl,
                          },
                  @"success": @(success)
                  });
}

- (void)photoBrowserDidChangeWithPhoto:(Photo * _Nonnull)photo index:(NSInteger)index {

}

@end

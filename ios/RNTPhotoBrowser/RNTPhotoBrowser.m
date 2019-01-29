
#import "RNTPhotoBrowser.h"
#import "RNTPhotoBrowser-Swift.h"

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

- (void)photoBrowserDidSaveWithPhoto:(Photo *)photo index:(NSInteger)index success:(BOOL)success {
    self.onSave(@{
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
    self.onChange(@{
                  @"index": @(index),
                  @"photo": @{
                          @"thumbnailUrl": photo.thumbnailUrl,
                          @"hightQualityUrl": photo.highQualityUrl,
                          @"rawQualityUrl": photo.rawUrl,
                          }
                  });
}

@end

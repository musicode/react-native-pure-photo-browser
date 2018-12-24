
#import "RNTThumbnailView.h"
#import "RNTPhotoBrowser-Swift.h"

@implementation RNTThumbnailView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView* view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        [self addSubview:view];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView = view;
    }
    self.dirtyUrl = @"";
    return self;
}

- (void)didMoveToSuperview {
    self.inSuperview = YES;
    if ([self.dirtyUrl length] > 0) {
        [self loadImage:self.dirtyUrl];
        self.dirtyUrl = @"";
    }
}

- (void)removeFromSuperview {
    self.inSuperview = NO;
}

- (void)loadImage:(NSString *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.inSuperview) {
            RNTPhotoBrowser.loadImage(self.imageView, url, ^(BOOL hasProgress) {
                self.onThumbnailLoadStart(@{});
            }, ^(int64_t loaded, int64_t total) {
                self.onThumbnailLoadProgress(@{
                                               @"loaded": [NSNumber numberWithInt:loaded],
                                               @"total": [NSNumber numberWithInt:total]
                                               });
            }, ^(BOOL success) {
                self.onThumbnailLoadEnd(@{
                                          @"success": success ? @YES : @NO
                                          });
            });
        } else {
            self.dirtyUrl = url;
        }
    });
}

@end

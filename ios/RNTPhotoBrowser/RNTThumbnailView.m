
#import "RNTThumbnailView.h"
#import "RNTPhotoBrowser-Swift.h"

@implementation RNTThumbnailView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView* view = [UIImageView new];
        view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        [self addSubview:view];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView = view;
    }
    self.isAlive = YES;
    return self;
}

- (void)dealloc {
    self.isAlive = NO;
}

- (void)refreshIfNeeded {
    if (self.width > 0 && self.height > 0 && self.url.length > 0 && self.isAlive && self.imageView != nil) {
        typeof(self) __weak __weak_self__ = self;
        
        RNTPhotoBrowser.loadImage(self.imageView, self.url, ^(BOOL hasProgress) {
            
            typeof(__weak_self__) __strong self = __weak_self__;
            if (self == nil) {
                return;
            }
            
            self.onThumbnailLoadStart(@{});
            
        }, ^(NSInteger loaded, NSInteger total) {
            
            typeof(__weak_self__) __strong self = __weak_self__;
            if (self == nil) {
                return;
            }
            
            self.onThumbnailLoadProgress(@{
                                           @"loaded": [NSNumber numberWithInteger:loaded],
                                           @"total": [NSNumber numberWithInteger:total]
                                           });
            
        }, ^(UIImage *image) {
            
            typeof(__weak_self__) __strong self = __weak_self__;
            if (self == nil) {
                return;
            }
            
            if (self.imageView != nil) {
                self.imageView.image = image;
            }

            self.onThumbnailLoadEnd(@{
                                      @"success": image != nil ? @YES : @NO
                                      });

        });
    }
}

@end

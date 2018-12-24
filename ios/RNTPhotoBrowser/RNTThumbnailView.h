
#import <React/RCTViewManager.h>
#import "RNTPhotoBrowser-Swift.h"

@interface RNTThumbnailView : UIView

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) bool inSuperview;
@property (nonatomic, assign) NSString *dirtyUrl;

@property (nonatomic, copy) RCTBubblingEventBlock onThumbnailLoadStart;
@property (nonatomic, copy) RCTBubblingEventBlock onThumbnailLoadProgress;
@property (nonatomic, copy) RCTBubblingEventBlock onThumbnailLoadEnd;

- (void)loadImage:(NSString *)url;

@end


#import <React/RCTViewManager.h>
#import "RNTPhotoBrowser-Swift.h"

@interface RNTThumbnailView : UIView

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic) bool isAlive;
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) RCTBubblingEventBlock onThumbnailLoadStart;
@property (nonatomic, copy) RCTBubblingEventBlock onThumbnailLoadProgress;
@property (nonatomic, copy) RCTBubblingEventBlock onThumbnailLoadEnd;

- (void)refreshIfNeeded;

@end

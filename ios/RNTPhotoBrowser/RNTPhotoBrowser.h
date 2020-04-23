
#import <React/RCTViewManager.h>

@class PhotoBrowser;

@interface RNTPhotoBrowser : UIView

@property (nonatomic, weak) PhotoBrowser *photoBrowser;

@property (nonatomic, copy) RCTBubblingEventBlock onTap;
@property (nonatomic, copy) RCTBubblingEventBlock onLongPress;
@property (nonatomic, copy) RCTBubblingEventBlock onSavePress;
@property (nonatomic, copy) RCTBubblingEventBlock onSaveComplete;
@property (nonatomic, copy) RCTBubblingEventBlock onDetectComplete;

@end

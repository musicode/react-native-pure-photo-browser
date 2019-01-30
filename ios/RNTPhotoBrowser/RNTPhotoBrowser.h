
#import <React/RCTViewManager.h>
#import "RNTPhotoBrowser-Swift.h"

@interface RNTPhotoBrowser : UIView

@property (nonatomic, weak) PhotoBrowser *photoBrowser;

@property (nonatomic, copy) RCTBubblingEventBlock onTap;
@property (nonatomic, copy) RCTBubblingEventBlock onLongPress;
@property (nonatomic, copy) RCTBubblingEventBlock onSaveComplete;
@property (nonatomic, copy) RCTBubblingEventBlock onDetectComplete;

@end

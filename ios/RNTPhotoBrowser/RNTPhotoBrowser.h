
#import <React/RCTViewManager.h>
#import "RNTPhotoBrowser-Swift.h"

@interface RNTPhotoBrowser : UIView

@property (nonatomic, weak) PhotoBrowser *photoBrowser;

@property (nonatomic, copy) RCTBubblingEventBlock onTap;
@property (nonatomic, copy) RCTBubblingEventBlock onLongPress;
@property (nonatomic, copy) RCTBubblingEventBlock onSave;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) RCTBubblingEventBlock onDetectResult;

@end

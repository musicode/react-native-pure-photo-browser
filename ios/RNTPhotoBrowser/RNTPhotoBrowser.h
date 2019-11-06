
#import <React/RCTViewManager.h>

@interface RNTPhotoBrowser : UIView

@property (nonatomic, weak) UIView *photoBrowser;

@property (nonatomic, copy) RCTBubblingEventBlock onTap;
@property (nonatomic, copy) RCTBubblingEventBlock onLongPress;
@property (nonatomic, copy) RCTBubblingEventBlock onSaveComplete;
@property (nonatomic, copy) RCTBubblingEventBlock onDetectComplete;

@end

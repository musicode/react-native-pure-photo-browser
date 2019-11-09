
#import "RNTPhotoBrowserModule.h"
#import "react_native_pure_photo_browser-Swift.h"

@implementation RNTPhotoBrowserModule

RCT_EXPORT_MODULE(RNTPhotoBrowser);

RCT_EXPORT_METHOD(saveLocalPhoto:(NSString *)path
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    [RNTPhotoBrowserConfiguration saveWithPath:path complete:^(BOOL success) {
        if (success) {
            resolve(@{});
        }
        else {
            reject(@"1", @"failed", nil);
        }
    }];
    
}

@end

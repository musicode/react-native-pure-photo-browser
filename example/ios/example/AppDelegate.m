/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <RNTPhotoBrowser/RNTPhotoBrowserModule.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"example"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  [RNTPhotoBrowserModule setImageLoader:^(UIImageView *imageView, NSString *url, void (^onLoadStart)(BOOL), void (^onLoadProgress)(int64_t, int64_t), void (^onLoadEnd)(BOOL)) {
    onLoadStart(true);
    UIImage *placeholder = [UIImage imageNamed:@"photo_browser_download"];
    if ([url hasPrefix:@"/"]) {
      [imageView sd_setImageWithURL:[NSURL fileURLWithPath:url]
                   placeholderImage:placeholder];
    }
    else {
      [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                   placeholderImage:placeholder
                            options:SDWebImageCacheMemoryOnly
                           progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                               onLoadProgress(receivedSize, expectedSize);
                             });
                           }
                          completed:^(UIImage * _Nullable imageB, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              onLoadEnd(error == nil);
                            });
                          }
              ];
    }
  }];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end

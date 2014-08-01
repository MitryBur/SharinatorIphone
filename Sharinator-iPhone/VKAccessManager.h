//
//  VKAccessManager.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKAccessToken.h"

@protocol VKAccessManagerDelegate;

@interface VKAccessManager : UIViewController <UIWebViewDelegate>

@property (nonatomic, readonly) VKAccessToken *vkToken;
@property (nonatomic) UIWebView *webView;
@property(nonatomic, assign) NSObject <VKAccessManagerDelegate> *delegate;
//@property (nonatomic, weak) id<VKAccessManagerDelegate> delegate;
@property (nonatomic, strong) UIViewController *viewController;

+ (VKAccessManager *) sharedInstance;
- (void) refreshTokenFromController:(UIViewController *)parentVC;

@end

@protocol VKAccessManagerDelegate <NSObject>
@optional
- (void)vkAccessManager:(VKAccessManager *)manager tokenRefreshed:(VKAccessToken *)token;
- (void)vkAccessManager:(VKAccessManager *)manager didFailWithError:(NSError *)error;
@end
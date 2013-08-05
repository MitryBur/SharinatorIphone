//
//  VKAccessManager.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKAccessToken.h"

@protocol VKAccessManagerDelegate <NSObject>
@optional
- (void) tokenRefreshed;
@end

@interface VKAccessManager : UIViewController <UIWebViewDelegate>

@property (nonatomic, readonly) VKAccessToken *vkToken;
@property (nonatomic) UIWebView *webView;

+ (VKAccessManager *) sharedInstance;
- (void) refreshToken:(UIViewController *)parentVC;

@end

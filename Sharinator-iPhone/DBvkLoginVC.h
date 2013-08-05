//
//  DBvkLoginVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 7/30/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBvkLoginVC : UIViewController <UIWebViewDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

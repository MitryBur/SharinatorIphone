//
//  VKAccessManager.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "VKAccessManager.h"
#import "AFNetworking.h"

@interface VKAccessManager()
@property (nonatomic) VKAccessToken *vkToken;
- (VKAccessToken *) retrieveTokenSilently;
- (VKAccessToken *) retrieveTokenUsingWebView:(UIViewController *)parentVC;
- (BOOL) isVKTokenActual;
@end
@implementation VKAccessManager

+ (VKAccessManager *) sharedInstance
{
    static VKAccessManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[VKAccessManager alloc] init];
    });
    return sharedInstance;
}

- (BOOL)extractToken:(NSString *)urlString
{
    if ([urlString hasPrefix:@"http://api.vkontakte.ru"]) {
        NSString *queryString = [urlString componentsSeparatedByString:@"#"][1];
        
        if ([queryString hasPrefix:@"access_token"]) {
            NSArray *parts = [queryString componentsSeparatedByString:@"&"];
            
            NSString *accessToken = [parts[0] componentsSeparatedByString:@"="][1];
            NSTimeInterval expirationInterval = [[parts[1] componentsSeparatedByString:@"="][1] doubleValue];
            NSUInteger vkID = [[parts[2] componentsSeparatedByString:@"="][1] unsignedIntValue];
            
            _vkToken = [[VKAccessToken alloc] initWithvkID:vkID accessToken:accessToken expirationInterval:expirationInterval];
            [VKAccessToken saveToken:_vkToken];
            NSLog(@"Token loaded %@\n token in memory:%@", [VKAccessToken loadToken].token, _vkToken.token);
            return YES;
        }
    }
    return NO;
}

- (VKAccessToken *) retrieveTokenSilently{
    NSURL *vkAuthUrl = [NSURL URLWithString:@"http://oauth.vk.com/authorize?"
                        "client_id=3759886&"
                        "scope=friends,events&"
                        "redirect_uri=http://api.vkontakte.ru/blank.html&"
                        "response_type=token"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://oauth.vk.com/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:[vkAuthUrl absoluteString]
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSString *urlString = [[[operation response] URL] absoluteString];
        NSLog(@"URL %@",urlString);
        [self extractToken:urlString];
        //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    return nil;
    
}
- (VKAccessToken *) retrieveTokenUsingWebView: (UIViewController *)parentVC{
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame: parentVC.view.frame];
    }
     NSURL *vkAuthUrl = [NSURL URLWithString:@"http://oauth.vk.com/authorize?"
     "client_id=3759886&"
     "scope=friends,events&"
     "redirect_uri=http://api.vkontakte.ru/blank.html&"
     "response_type=token"];
     NSURLRequest *request = [NSURLRequest requestWithURL:vkAuthUrl];
    
     self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [parentVC presentViewController:self animated:YES completion:NULL];
    
    return nil;
}
- (VKAccessToken *) vkToken{
    _vkToken = [VKAccessToken loadToken];
    if (!_vkToken) return nil;

    if (_vkToken.isValid){
        return _vkToken;
    }
    else
        if (_vkToken.isExpired) {
            
        }
    return nil;
}
- (void) refreshToken:(UIViewController *)parentVC{
    [self retrieveTokenUsingWebView:parentVC];
}

- (BOOL) isVKTokenActual{
    return NO;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
	NSLog(@"RequestLoadFinished");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //102 = Frame load interrupted
    if (error.code != 102) {
        NSLog(@"Error: %@", error);
    }
}

- (void)hideWebView{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Dismissed");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
	NSString *urlString = [[request URL] absoluteString];
	NSLog(@"%s", __FUNCTION__);
	if ([self extractToken:urlString])
    {
        if ([self isBeingPresented])
        {
            [self performSelector:@selector(hideWebView) withObject:nil afterDelay:1];
        }
        return NO;
    }
    else
        return YES;
}


@end

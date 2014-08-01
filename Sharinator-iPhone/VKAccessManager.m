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
//- (BOOL) isVKTokenActual;
@end
@implementation VKAccessManager{
    UIViewController *_parentVC;
}



+ (VKAccessManager *) sharedInstance
{
    static VKAccessManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[VKAccessManager alloc] init];
    });
    return sharedInstance;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (BOOL)parseTokenURL:(NSString *)urlString
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
                        "scope=friends,events,offline&"
                        "redirect_uri=http://api.vkontakte.ru/blank.html&"
                        "response_type=token"];
    
    AFHTTPSessionManager *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://oauth.vk.com/"]];
    httpClient.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpClient GET:[vkAuthUrl absoluteString] parameters:nil success:
     ^(NSURLSessionDataTask *task, id responseObject) {
        // Print the response body in text
        NSString *urlString = [[[task response] URL] absoluteString];
        NSLog(@"URL %@",urlString);
        if ([self parseTokenURL:urlString]){
            [self.delegate vkAccessManager:self tokenRefreshed:[VKAccessToken loadToken]];
        }
        else
            [self retrieveTokenUsingWebView:_parentVC];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [self retrieveTokenUsingWebView:_parentVC];
    }];
    
    return nil;
    
}
- (VKAccessToken *) retrieveTokenUsingWebView: (UIViewController *)parentVC{
    if (!self.webView) {
        NSLog(@"%s", __FUNCTION__);
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        //Status bar height = 20
        screenBounds.origin.y += 20;
        //screenBounds.size.height -= 20;
        NSLog(@"Width: %f Height:%f",screenBounds.size.width, screenBounds.size.height);
        self.webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 20, screenBounds.size.width, screenBounds.size.height)];
        self.webView.scalesPageToFit = YES;
        self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.webView.delegate = self;
    }
     NSURL *vkAuthUrl = [NSURL URLWithString:@"http://oauth.vk.com/authorize?"
     "client_id=3759886&"
     "scope=friends,events,offline&"
     "redirect_uri=http://api.vkontakte.ru/blank.html&"
     "response_type=token"];
     NSURLRequest *request = [NSURLRequest requestWithURL:vkAuthUrl];
    
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [parentVC presentViewController:self animated:YES completion:NULL];
    return nil;
}
- (VKAccessToken *) vkToken{
    _vkToken = [VKAccessToken loadToken];
    if (_vkToken){ //&& _vkToken.isValid){
        return _vkToken;
    }
    /*else
        if (_vkToken.isExpired) {
            [self retrieveTokenSilently];
        }
     */
    //Otherwise
    return nil;
}
- (void) refreshTokenFromController:(UIViewController *)parentVC{
    _parentVC = parentVC;
    [self retrieveTokenSilently];
}
/*
- (BOOL) isVKTokenActual{
    return NO;
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	NSLog(@"RequestLoadFinished");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //102 = Frame load interrupted
    if (error.code != 102) {
        NSLog(@"Error: %@", error);
        [self.delegate vkAccessManager:self didFailWithError:error];
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
	if ([self parseTokenURL:urlString])
    {
        NSLog(@"URL str: %@", [[request URL] absoluteString]);
        //[webView stopLoading];
        [self hideWebView];

        /*if ([self isBeingPresented])
        {
            [self hideWebView];
            //[self performSelector:@selector(hideWebView) withObject:nil afterDelay:1];
        }*/
        NSArray *args = @[self, [VKAccessToken loadToken]];

        [self.delegate performSelector:@selector(vkAccessManager:tokenRefreshed:) withObject:args afterDelay:0.0];

        return NO;
    }
    else
        return YES;
}


@end

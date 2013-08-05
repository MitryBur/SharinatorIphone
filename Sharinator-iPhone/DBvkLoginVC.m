//
//  DBvkLoginVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 7/30/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBvkLoginVC.h"
#import "DBAppDelegate.h"

#import "AFNetworking.h"
#import "VKAccessManager.h"

@interface DBvkLoginVC (){
    NSURLRequest *_request;
}
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *tokenExpiration;
@end

@implementation DBvkLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    /*NSURL *vkAuthUrl = [NSURL URLWithString:@"http://oauth.vk.com/authorize?"
                      "client_id=3759886&"
                      "scope=friends,events&"
                      "redirect_uri=http://api.vkontakte.ru/blank.html&"
                      "response_type=token"];
    _request = [NSURLRequest requestWithURL:vkAuthUrl];
    
    //(void)[[NSURLConnection alloc] initWithRequest:_request delegate:self];
    self.webView.delegate = self;
    [self.webView loadRequest:_request];
  
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
        NSLog(@"URL %@",[[[operation response] URL] absoluteString]);
        //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];*/

    
}

-(void)viewDidAppear:(BOOL)animated
{
   // if (![[VKAccessManager sharedInstance] vkToken])
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [[VKAccessManager sharedInstance] refreshToken:self];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	
	//[(DBAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
	//NSLog(@"RequestLoadFinished");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	//[(DBAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
	//[communicatingWithVK stopAnimating];
    
}


NSString* getStringBetweenStrings(NSString *first,NSString*second,NSString*main){
	NSRange rangeofFirst = [main rangeOfString:first];
	NSRange rangeOfSecond = [main rangeOfString:second];
	if ((rangeofFirst.length == 0) || (rangeOfSecond.length == 0)) {
		return nil;
	}
	NSString *result = [[main substringFromIndex:rangeofFirst.location+rangeofFirst.length]
						substringToIndex:
						[[main substringFromIndex:rangeofFirst.location+rangeofFirst.length] rangeOfString:second].location];
	return result;
}

- (void)getSessionParameters: (NSString *) urlString  {
	self.accessToken = getStringBetweenStrings(@"access_token=",@"&expires_in", urlString);
	NSLog(@"%@", self.accessToken);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
navigationType:(UIWebViewNavigationType)navigationType{
	NSURL *url = [request URL];
	NSString *urlString = [url absoluteString];
	
	NSRange textRange;
	textRange =[urlString rangeOfString:@"blank.html#access_token"];
	if(textRange.location != NSNotFound){
		[self getSessionParameters: urlString];
		NSLog(@"Logged in");
		return NO;
	}
	else{
		return YES;
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response: %@", [response description]);

}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    NSLog(@"redirect: %@", [[request URL] absoluteString]);
    return request;
}


@end

//
//  ShariClient.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariClient.h"
#import "AFJSONRequestOperation.h"


static NSString * const kSharinatorAPIBaseURLString = @"http://shariserver.herokuapps.com/v1/";

@implementation ShariClient
+ (ShariClient *) sharedInstance
{
    static ShariClient *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[ShariClient alloc] initWithBaseURL:[NSURL URLWithString:kSharinatorAPIBaseURLString]];
    });
    return sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}


@end

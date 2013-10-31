//
//  VKAccessTokenTests.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 30/10/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VKAccessToken.h"
@interface VKAccessTokenTests : XCTestCase{
    VKAccessToken *token;
}
@end

@implementation VKAccessTokenTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    token = [[VKAccessToken alloc] initWithvkID:1 accessToken:@"token" expirationInterval:2];
    [VKAccessToken saveToken:token];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    token = nil;
}

- (void)testTokenSaveNLoad
{
    VKAccessToken *loadedToken = [VKAccessToken loadToken];
    XCTAssertEqualObjects(token.token, loadedToken.token, @"Token is loaded incorrectly after save");
    
}
- (void)testTokenValid
{
    XCTAssertTrue([token isValid], @"Token validation check fails");
    token = [[VKAccessToken alloc] initWithvkID:1 accessToken:@"token" expirationInterval:0];
    XCTAssertFalse([token isValid], @"Token validation check fails");
}

@end

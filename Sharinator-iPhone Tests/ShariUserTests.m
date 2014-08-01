//
//  ShariUserTests.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 26/02/14.
//  Copyright (c) 2014 Dmitry Burmistrov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ShariUser.h"

@interface ShariUserTests : XCTestCase

@end

@implementation ShariUserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testThatUserExists
{
    ShariUser *user = [[ShariUser alloc] init];
    XCTAssertNotNil(user, @"Should be able to create a user");
}

- (void)testThatUserCanBeAssignedID
{
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], @"id", nil, @"social_profile", nil];
    ShariUser *user = [[ShariUser alloc] initWithRawDictionary:userParams];
    XCTAssertEqual(user.id, 1, @"Should be able to parse id from dictionary");
}

@end

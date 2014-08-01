//
//  ShariAPI.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 15/03/14.
//  Copyright (c) 2014 Dmitry Burmistrov. All rights reserved.
//

#import "ShariAPI.h"
#import "ShariHTTPClient.h"

@interface ShariAPI()
+ (ShariHTTPClient *)clientWithSuccess:(void (^)(id))success failure:(void (^)(id))failure;
@end
@implementation ShariAPI

+ (ShariHTTPClient *)clientWithSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    ShariHTTPClient *client = [ShariHTTPClient sharedInstance];
    client.successBlock = success;
    client.failureBlock = failure;
    return client;
}

+(void)authenticateWithSuccess:(void (^)(id response))success
                    failure:(void (^)(id error))failure
{
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient authenticate];
}

+(void)userEventsWithSuccess:(void (^)(id response))success
                     failure:(void (^)(id error))failure
{
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient getByClass:[ShariEvent class]];
}

+(void)expensesOfEvent:(ShariEvent *)event
           withSuccess:(void (^)(id response))success
               failure:(void (^)(id error))failure
{
    NSString *urlPrefix = [NSString stringWithFormat:@"events/%ld/", (long)event.id];
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient get:[ShariExpense class] withURLPrefix:urlPrefix];
}

+(void)userExpensesWithSuccess:(void (^)(id response))success
                       failure:(void (^)(id error))failure
{
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient getByClass:[ShariExpense class]];
}

+(void)membersOfEvent:(ShariEvent *)event
          withSuccess:(void (^)(id response))success
              failure:(void (^)(id error))failure
{
    NSString *urlPrefix = [NSString stringWithFormat:@"events/%ld/", (long)event.id];
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient get:[ShariUser class] withURLPrefix:urlPrefix];
}

+(void)payersForExpense:(ShariExpense *)expense
            withSuccess:(void (^)(id response))success
                failure:(void (^)(id error))failure
{
    NSString *urlPrefix = [NSString stringWithFormat:@"expenses/%ld/", (long)expense.id];
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient get:[ShariUser class] withURLPrefix:urlPrefix];
}
+(void)userVKFriendsWithSuccess:(void (^)(id response))success
                        failure:(void (^)(id error))failure
{
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient getVKFriends];
}

+(void)addEvent:(ShariEvent *)event
    withSuccess:(void (^)(id response))success
        failure:(void (^)(id error))failure
{
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient post:[ShariEvent class] data:[event dictionaryRepresentation]];
}

+(void)addExpense:(ShariExpense *)expense
    withSuccess:(void (^)(id response))success
        failure:(void (^)(id error))failure
{
    ShariHTTPClient *configuredClient = [self clientWithSuccess:success failure:failure];
    [configuredClient post:[ShariExpense class] data:[expense dictionaryRepresentation]];
}

@end

//
//  ShariAPI.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 15/03/14.
//  Copyright (c) 2014 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShariHeaders.h"
#import "ShariHTTPClient.h"
@interface ShariAPI : NSObject

+(void)authenticateWithSuccess:(void (^)(id response))success
                    failure:(void (^)(id error))failure;

+(void)userEventsWithSuccess:(void (^)(id response))success
                     failure:(void (^)(id error))failure;

+(void)expensesOfEvent:(ShariEvent *)event
           withSuccess:(void (^)(id response))success
               failure:(void (^)(id error))failure;

+(void)userExpensesWithSuccess:(void (^)(id response))success
                       failure:(void (^)(id error))failure;

+(void)membersOfEvent:(ShariEvent *)event
          withSuccess:(void (^)(id response))success
              failure:(void (^)(id error))failure;

+(void)payersForExpense:(ShariExpense *)expense
            withSuccess:(void (^)(id response))success
                failure:(void (^)(id error))failure;
+(void)userVKFriendsWithSuccess:(void (^)(id response))success
                failure:(void (^)(id error))failure;

+(void)addEvent:(ShariEvent *)event
    withSuccess:(void (^)(id response))success
        failure:(void (^)(id error))failure;

+(void)addExpense:(ShariExpense *)expense
    withSuccess:(void (^)(id response))success
        failure:(void (^)(id error))failure;

@end

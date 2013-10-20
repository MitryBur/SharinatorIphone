//
//  ShariClient.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "VKAccessToken.h"
@protocol ShariClientDelegate;

@interface ShariClient : AFHTTPClient
@property (nonatomic, weak) id<ShariClientDelegate> delegate;
@property (nonatomic, strong) VKAccessToken *vkToken;

- (void)authenticate;
- (void)get:(Class)class ;
- (void)post:(Class)class data:(NSDictionary *)dictionary;

//Temp
- (void)getVKFriends;

+ (ShariClient *) sharedInstance;
@end

@protocol ShariClientDelegate <NSObject>
-(void)shariClient:(ShariClient *)client didFailWithError:(NSError *)error;
@optional
-(void)shariClient:(ShariClient *)client didGetWithResponse:(id)response;
-(void)shariClient:(ShariClient *)client didPostWithResponse:(id)response;
@end
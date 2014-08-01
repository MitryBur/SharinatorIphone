//
//  ShariHTTPClient.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "VKAccessToken.h"
//@protocol ShariHTTPClientDelegate;

@interface ShariHTTPClient : AFHTTPSessionManager
//@property (nonatomic, weak) id<ShariHTTPClientDelegate> delegate;
@property (nonatomic, strong) VKAccessToken *vkToken;
@property (copy) void (^successBlock)(id response);
@property (copy) void (^failureBlock)(id error);

- (void)authenticate;

//Deprecated
- (void)get:(Class)class;

- (void)getByClass:(Class)class;
- (void)get:(Class)class withURLPrefix:(NSString *)prefix;

- (void)getLocally:(Class)class;

- (void)post:(Class)class data:(NSDictionary *)dictionary;


- (void)getVKFriends;

+ (ShariHTTPClient *) sharedInstance;
@end

/*
@protocol ShariHTTPClientDelegate <NSObject>
-(void)shariClient:(ShariHTTPClient *)client didFailWithError:(NSError *)error;
@optional
-(void)shariClient:(ShariHTTPClient *)client didGetWithResponse:(id)response;
-(void)shariClient:(ShariHTTPClient *)client didPostWithResponse:(id)response;

 @end
*/
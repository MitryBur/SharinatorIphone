//
//  ShariClient.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariClient.h"
#import "AFJSONRequestOperation.h"
#import "VKAccessManager.h"
#import "ShariEvent.h"
#import "ShariSocial.h"


static NSString * const kSharinatorAPIBaseURLString = @"http://shariserver.herokuapp.com/v1/";
//static NSString * const kSharinatorAPIBaseURLString = @"http://localhost:3333/v1/";

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

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
}

- (void)authenticate{
    NSLog(@"%s",__FUNCTION__);
    NSMutableDictionary  *parameters = [NSMutableDictionary  dictionary];
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    NSLog(@"%@, %d", manager.vkToken.token, manager.vkToken.vkID);
    [parameters setObject:manager.vkToken.token forKey:@"access_token"];
    [parameters setObject:[NSNumber numberWithInteger:manager.vkToken.vkID] forKey:@"user_id"];

    [self getPath:@"vk"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(shariClient:didGetWithResponse:)])
                  [self.delegate shariClient:self didGetWithResponse:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError  *error) {
              if([self.delegate respondsToSelector:@selector(shariClient:didFailWithError:)])
                  [self.delegate shariClient:self didFailWithError:error];
          }];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

}
- (void)getVKFriends{
    
    NSLog(@"%s",__FUNCTION__);
    
    
    NSMutableDictionary  *parameters = [NSMutableDictionary  dictionary];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    NSLog(@"%@, %d", manager.vkToken.token, manager.vkToken.vkID);
    [parameters setObject:manager.vkToken.token forKey:@"access_token"];
    
    [self getPath:@"vk/friends"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(shariClient:didGetWithResponse:)])
              {
                  NSMutableArray *objects = [[NSMutableArray alloc] init];
                  for (NSDictionary *d in [responseObject objectForKey:@"response"]) {
                      id object = [[ShariSocial alloc] initWithRawDictionary:d];
                      [objects addObject:object];
                  }
                  [self.delegate shariClient:self didGetWithResponse:(NSArray *)objects];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError  *error) {
              if([self.delegate respondsToSelector:@selector(shariClient:didFailWithError:)])
                  [self.delegate shariClient:self didFailWithError:error];
          }];
}

- (void)get:(Class)class{
    
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",class);

    NSMutableDictionary  *parameters = [NSMutableDictionary  dictionary];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    NSLog(@"%@, %d", manager.vkToken.token, manager.vkToken.vkID);
    [parameters setObject:manager.vkToken.token forKey:@"access_token"];
    
    [self getPath:[class requestPath]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(shariClient:didGetWithResponse:)])
              {
                  NSMutableArray *objects = [[NSMutableArray alloc] init];
                  for (NSDictionary *d in responseObject) {
                      id object = [[class alloc] initWithRawDictionary:d];
                      [objects addObject:object];
                  }
                  [self.delegate shariClient:self didGetWithResponse:objects];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError  *error) {
              if([self.delegate respondsToSelector:@selector(shariClient:didFailWithError:)])
                  [self.delegate shariClient:self didFailWithError:error];
          }];
}
- (void)post:(Class)class data:(NSDictionary *)dictionary{
    
    NSLog(@"%s",__FUNCTION__);
    NSMutableDictionary  *parameters = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    NSLog(@"%@, %d", manager.vkToken.token, manager.vkToken.vkID);
    [parameters setObject:manager.vkToken.token forKey:@"access_token"];

    NSLog(@"%@", [parameters description]);

    [self postPath:[class requestPath]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(shariClient:didPostWithResponse:)])
                  [self.delegate shariClient:self didPostWithResponse:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError  *error) {
              NSLog(@"%@",[[[operation request] allHTTPHeaderFields] valueForKey:@"Content-Type"]);

              if([self.delegate respondsToSelector:@selector(shariClient:didFailWithError:)])
                  [self.delegate shariClient:self didFailWithError:error];
          }];
}
@end

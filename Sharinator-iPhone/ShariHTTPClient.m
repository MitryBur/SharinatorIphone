//
//  ShariClient.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariHTTPClient.h"
#import "VKAccessManager.h"
#import "ShariEvent.h"
#import "ShariUser.h"
#import "ShariSocialProfile.h"

#import "DBDocumentsManager.h"


//static NSString * const kSharinatorAPIBaseURLString = @"http://shariserver.herokuapp.com/v1/";
static NSString * const kSharinatorAPIBaseURLString = @"http://localhost:3333/v1/";
enum {
    vkFriends,
    authentication
};
@implementation ShariHTTPClient
+ (ShariHTTPClient *) sharedInstance
{
    static ShariHTTPClient *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[ShariHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSharinatorAPIBaseURLString]];
    });
    //Reinitialize
    sharedInstance.successBlock = nil;
    sharedInstance.failureBlock = nil;
    //sharedInstance.delegate = nil;
    
    return sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];

    return self;
}

- (void)authenticate{
    NSLog(@"%s",__FUNCTION__);
    NSMutableDictionary  *parameters = [NSMutableDictionary  dictionary];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    parameters[@"access_token"] = manager.vkToken.token;
    parameters[@"user_id"] = [NSNumber numberWithInteger:manager.vkToken.vkID];

    //self.requestSerializer = [AFHTTPRequestSerializer serializer];
    //self.responseSerializer = [AFHTTPResponseSerializer serializer];

    [self GET:@"vk"
       parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
              //self.requestSerializer = [AFJSONRequestSerializer serializer];
              //self.responseSerializer = [AFJSONResponseSerializer serializer];
              
              if (self.successBlock) {
                  self.successBlock(responseObject);
              }


              //if([self.delegate respondsToSelector:@selector(shariClient:didGetWithResponse:)])
                //  [self.delegate shariClient:self didGetWithResponse:responseObject];
          }
          failure:^(NSURLSessionDataTask *task, NSError  *error) {
              //if([self.delegate respondsToSelector:@selector(shariClient:didFailWithError:)])
              //    [self.delegate shariClient:self didFailWithError:error];
              
              //self.requestSerializer = [AFJSONRequestSerializer serializer];
              //self.responseSerializer = [AFJSONResponseSerializer serializer];
              
              if (self.failureBlock) {
                  self.failureBlock(error);
              }
          }];

}
- (void)getVKFriends{
    
    NSLog(@"%s",__FUNCTION__);
    
    NSMutableDictionary  *parameters = [NSMutableDictionary  dictionary];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    NSLog(@"%@, %lu", manager.vkToken.token, (unsigned long)manager.vkToken.vkID);
    parameters[@"access_token"] = manager.vkToken.token;
    
    [self GET:@"vk/friends"
       parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSMutableArray *objects = [[NSMutableArray alloc] init];
              for (NSDictionary *d in responseObject[@"response"]) {
                  id socialProfile = [[ShariSocialProfile alloc] initWithVKDictionary:d];
                  ShariUser *user = [[ShariUser alloc] init];
                  user.social = socialProfile;
                  [objects addObject:user];
              }
              //[self.delegate shariClient:self didGetWithResponse:(NSArray *)objects];
              if (self.successBlock) {
                  self.successBlock(objects);
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError  *error) {
              //if([self.delegate respondsToSelector:@selector(shariClient:didFailWithError:)])
               //   [self.delegate shariClient:self didFailWithError:error];
              if (self.failureBlock) {
                  self.failureBlock(error);
              }
          }];
}

- (void)getByClass:(Class)class
{
    NSLog(@"%@",class);
    [self get:class withURLPrefix:@""];

}
- (void)get:(Class)class
{
    NSLog(@"%@",class);
    [self get:class withURLPrefix:@""];
}
- (void)get:(Class)class withURLPrefix:(NSString *)prefix
{
    NSLog(@"%s",__FUNCTION__);

    NSMutableDictionary  *parameters = [NSMutableDictionary  dictionary];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    NSLog(@"%@, %lu", manager.vkToken.token, (unsigned long)manager.vkToken.vkID);
    parameters[@"access_token"] = manager.vkToken.token;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", prefix, [class requestPath]];
    [self GET:urlString
       parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSMutableArray *objects = [[NSMutableArray alloc] init];
              for (NSDictionary *d in responseObject) {
                  id object = [[class alloc] initWithRawDictionary:d];
                  [objects addObject:object];
              }
              //[self.delegate shariClient:self didGetWithResponse:objects];
              if (self.successBlock) {
                  self.successBlock(objects);
              }

          }
          failure:^(NSURLSessionDataTask *task, NSError  *error) {
              //if([self.delegate respondsToSelector:@selector(shariClient:didFailWithError:)])
              //    [self.delegate shariClient:self didFailWithError:error];
              if (self.failureBlock) {
                  self.failureBlock(error);
              }
          }];
}
#warning possibly incomplete implementation
- (void)getLocally:(Class)class{
    
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",class);
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", class, @"json"];
    [DBDocumentsManager copyFileToDocuments:fileName];
    NSString *fileContents = [DBDocumentsManager readFileFromDocuments:fileName];
    NSLog(@"%@",fileContents);
    NSData *data = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //if([self.delegate respondsToSelector:@selector(shariClient:didGetWithResponse:)])
    {
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        for (NSDictionary *d in responseObject) {
            id object = [[class alloc] initWithRawDictionary:d];
            [objects addObject:object];
        }
        //[self.delegate shariClient:self didGetWithResponse:objects];
        if (self.successBlock) {
            self.successBlock(objects);
        }
    }
}

- (void)post:(Class)class data:(NSDictionary *)dictionary{
    
    NSLog(@"%s",__FUNCTION__);
    NSMutableDictionary  *parameters = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    NSLog(@"%@, %lu", manager.vkToken.token, (unsigned long)manager.vkToken.vkID);
    parameters[@"access_token"] = manager.vkToken.token;

    NSLog(@"%@", [parameters description]);

    [self POST:[class requestPath]
       parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
              //if([self.delegate respondsToSelector:@selector(shariClient:didPostWithResponse:)])
               //   [self.delegate shariClient:self didPostWithResponse:responseObject];
              if (self.successBlock) {
                  self.successBlock(responseObject);
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError  *error) {
              if (self.failureBlock) {
                  self.failureBlock(error);
              }
              //if([self.delegate respondsToSelector:@selector(shariClient:didFailWithError:)])
              //    [self.delegate shariClient:self didFailWithError:error];
          }];
}
@end

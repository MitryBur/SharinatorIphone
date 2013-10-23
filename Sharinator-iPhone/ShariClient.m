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

#import "DBDocumentsManager.h"


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
    parameters[@"access_token"] = manager.vkToken.token;
    parameters[@"user_id"] = [NSNumber numberWithInteger:manager.vkToken.vkID];

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
    parameters[@"access_token"] = manager.vkToken.token;
    
    [self getPath:@"vk/friends"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(shariClient:didGetWithResponse:)])
              {
                  NSMutableArray *objects = [[NSMutableArray alloc] init];
                  for (NSDictionary *d in responseObject[@"response"]) {
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
    parameters[@"access_token"] = manager.vkToken.token;
    
    [self getPath:[class requestPath]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(shariClient:didGetWithResponse:)])
              {
                  NSMutableArray *objects = [[NSMutableArray alloc] init];
                  for (NSDictionary *d in responseObject) {
                      NSLog(@"aaa %@", d);
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

- (void)getLocally:(Class)class{
    
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",class);
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", class, @"json"];
    [DBDocumentsManager copyFileToDocuments:fileName];
    NSString *fileContents = [DBDocumentsManager readFileFromDocuments:fileName];
    NSLog(@"%@",fileContents);
    NSData *data = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if([self.delegate respondsToSelector:@selector(shariClient:didGetWithResponse:)])
    {
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        for (NSDictionary *d in responseObject) {
            NSLog(@"aaa %@", d);

            id object = [[class alloc] initWithRawDictionary:d];
            [objects addObject:object];
        }
        [self.delegate shariClient:self didGetWithResponse:objects];
    }
}


- (void)post:(Class)class data:(NSDictionary *)dictionary{
    
    NSLog(@"%s",__FUNCTION__);
    NSMutableDictionary  *parameters = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    VKAccessManager *manager = [VKAccessManager sharedInstance];
    NSLog(@"%@, %d", manager.vkToken.token, manager.vkToken.vkID);
    parameters[@"access_token"] = manager.vkToken.token;

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

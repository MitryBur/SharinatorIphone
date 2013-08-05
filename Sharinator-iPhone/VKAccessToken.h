//
//  VKAccessToken.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAccessToken : NSObject <NSCoding>

@property (nonatomic, readonly) NSUInteger vkID;
@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) NSTimeInterval creationTime;
@property (nonatomic, readonly) NSTimeInterval expirationInterval;

@property (nonatomic, readonly) BOOL isValid;
@property (nonatomic, readonly) BOOL isExpired;

- (instancetype)initWithvkID:(NSUInteger)vkID
                 accessToken:(NSString *)token
          expirationInterval:(NSTimeInterval)expirationInterval;

+ (VKAccessToken *)loadToken;
+ (void)saveToken:(VKAccessToken *)token;

@end

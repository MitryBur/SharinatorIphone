//
//  VKAccessToken.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "VKAccessToken.h"

static NSString* const kVKTokenKey = @"vk_token";

@interface VKAccessToken()
@property (nonatomic) NSUInteger vkID;
@property (nonatomic) NSString *token;
@property (nonatomic) NSTimeInterval creationTime;
@property (nonatomic) NSTimeInterval expirationInterval;
@end

@implementation VKAccessToken

- (instancetype) initWithCoder:(NSCoder*)decoder {
    if (self = [super init]) {
        self.token = [decoder decodeObjectForKey:@"access_token"];
        self.vkID = [decoder decodeIntegerForKey:@"vkID"];
        self.creationTime = [decoder decodeDoubleForKey:@"created_at"];
        self.expirationInterval = [decoder decodeDoubleForKey:@"expires_in"];
    }
    return self;
}

- (instancetype)initWithvkID:(NSUInteger)vkID
                 accessToken:(NSString *)token
          expirationInterval:(NSTimeInterval)expirationInterval
{    
    if (self = [super init]) {
        self.vkID = vkID;
        self.token = [token copy];
        self.expirationInterval = expirationInterval;
        self.creationTime = [[NSDate date] timeIntervalSince1970];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.token forKey:@"access_token"];
    [encoder encodeInteger:self.vkID forKey:@"vkID"];
    [encoder encodeDouble:self.creationTime forKey:@"created_at"];
    [encoder encodeDouble:self.expirationInterval forKey:@"expires_in"];    
}

- (BOOL) isExpired
{
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    return (self.creationTime + self.expirationInterval < currentTimestamp);
}

- (BOOL) isValid
{
    return (self.token && ![self isExpired]);
}

+ (void)saveToken:(VKAccessToken *)token {
    NSData *encodedToken = [NSKeyedArchiver archivedDataWithRootObject:token];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedToken forKey:kVKTokenKey];
    [defaults synchronize];
    
}

+ (VKAccessToken *)loadToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedToken = [defaults objectForKey:kVKTokenKey];
    VKAccessToken *token = (VKAccessToken *)[NSKeyedUnarchiver unarchiveObjectWithData: encodedToken];
    return token;
}

@end

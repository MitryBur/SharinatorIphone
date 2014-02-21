//
//  ShariUser.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 7/31/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariUser.h"
#import "ShariSocialProfile.h"

@implementation ShariUser
- (instancetype)initWithRawDictionary:(NSDictionary *)dictionary{
    if ((self = [self init])) {
        self.id = [dictionary[@"id"] integerValue];
        self.social = [[ShariSocialProfile alloc] initWithRawDictionary:dictionary[@"social_profile"]];
        self.social.user = self;
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    if (self.id) {
        [objects addObject:@(self.id)];
        [keys addObject:@"id"];
    }

    if (self.social) {
        [keys addObject:@"social_profile_attributes"];
        [objects addObject:[self.social dictionaryRepresentation]];
    }
    return [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
}
+ (NSString *)requestPath{
    return @"users.json";
}
@end

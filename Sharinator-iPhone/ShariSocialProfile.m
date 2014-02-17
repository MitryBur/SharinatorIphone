//
//  ShariSocialProfile.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariSocialProfile.h"
//#import "ShariUser.h"

@implementation ShariSocialProfile
- (instancetype)initWithRawDictionary:(NSDictionary *)dictionary{
    if ((self = [self init])) {
        //self.id = [dictionary[@"user_id"] integerValue];
        self.name = dictionary[@"name"];
        self.surname = dictionary[@"surname"];
        self.vkID = [dictionary[@"vk_id"] integerValue];
    }
    return self;
}
- (instancetype)initWithVKDictionary:(NSDictionary *)dictionary{
    if ((self = [self init])) {
        //self.id = [dictionary[@"user_id"] integerValue];
        self.name = dictionary[@"first_name"];
        self.surname = dictionary[@"last_name"];
        self.vkID = [dictionary[@"uid"] integerValue];
    }
    return self;
}
- (NSDictionary *)dictionaryRepresentation{

    NSArray *objects = @[self.name, self.surname, @(self.vkID)];
    NSArray *keys = @[@"name", @"surname", @"vk_id"];
    
    return [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
}
+ (NSString *)requestPath{
    return @"social_profiles.json";
}
@end

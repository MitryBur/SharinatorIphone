//
//  ShariSocial.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariSocial.h"
//#import "ShariUser.h"

@implementation ShariSocial
- (instancetype)initWithRawDictionary:(NSDictionary *)dictionary{
    if ((self = [self init])) {
        self.id = [dictionary[@"user_id"] integerValue];
        self.name = dictionary[@"first_name"];
        self.surname = dictionary[@"last_name"];
        self.vkID = [dictionary[@"uid"] integerValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    NSArray *objects = @[@(self.id),
                         self.name, self.surname, @(self.vkID)];
    NSArray *keys = @[@"user_id", @"first_name", @"last_name", @"uid"];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}
@end

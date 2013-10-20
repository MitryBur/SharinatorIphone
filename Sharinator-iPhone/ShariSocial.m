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
        self.id = [[dictionary objectForKey:@"user_id"] integerValue];
        self.name = [dictionary objectForKey:@"first_name"];
        self.surname = [dictionary objectForKey:@"last_name"];
        self.vkID = [[dictionary objectForKey:@"uid"] integerValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.id],self.name, self.surname, [NSNumber numberWithInteger:self.vkID], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"user_id", @"first_name", @"last_name", @"uid", nil];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}
@end

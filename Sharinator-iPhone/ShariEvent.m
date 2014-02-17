//
//  ShariEvent.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/7/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariEvent.h"


@implementation ShariEvent

- (instancetype)initWithRawDictionary:(NSDictionary *)dictionary{
    
    if ((self = [self init])) {
        self.title = dictionary[@"title"];
        self.description = dictionary[@"description"];
        self.members = [ShariUser processJSONArray:dictionary[@"users"]];
    }
    return self;
}

- (NSString *) processMembers{
    NSMutableArray *userDicArray = [[NSMutableArray alloc] init];
    for (ShariUser *u in self.members) {
        [userDicArray addObject:[u dictionaryRepresentation]];
    }
    return [userDicArray copy];
}
- (NSDictionary *)dictionaryRepresentation{
    NSMutableArray *keys = [[NSMutableArray alloc] initWithObjects:@"title", @"description", nil];
    NSMutableArray *objects = [[NSMutableArray alloc] initWithObjects:self.title, self.description, nil];
    if (self.members) {
        [keys addObject:@"users_attributes"];
        [objects addObject:[self processMembers]];
    }
    return [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
}

+ (NSString *)requestPath{
    return @"events.json";
}

@end

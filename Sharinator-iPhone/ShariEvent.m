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
        self.title = [dictionary objectForKey:@"title"];
        self.description = [dictionary objectForKey:@"description"];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    return [[NSDictionary alloc] initWithObjectsAndKeys:self.title, @"title",self.description, @"description", nil];
}

+ (NSString *)requestPath{
    return @"events.json";
}

@end

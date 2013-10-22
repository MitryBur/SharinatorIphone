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
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    return @{@"title": self.title,@"description": self.description};
}

+ (NSString *)requestPath{
    return @"events.json";
}

@end

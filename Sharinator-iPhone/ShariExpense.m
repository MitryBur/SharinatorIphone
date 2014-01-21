//
//  ShariExpense.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 23/10/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariExpense.h"

@implementation ShariExpense
- (instancetype)initWithRawDictionary:(NSDictionary *)dictionary{
    if ((self = [self init])) {
        self.title = dictionary[@"title"];
        self.description = dictionary[@"description"];
        self.currency = dictionary[@"currency"];
        self.price = [NSNumber numberWithFloat:[dictionary[@"price"] floatValue]];
        self.payer = [[ShariSocial alloc] processJSONString:dictionary[@"payer"]];
        self.members = dictionary[@"members"];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    return @{@"title": self.title,@"description": self.description, @"currency":self.currency, @"price": self.price, @"payer":self.payer, @"members":self.members};
}

+ (NSString *)requestPath{
    return @"expenses.json";
}
@end

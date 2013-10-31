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
        self.payerID = [dictionary[@"payer_id"] integerValue];
        self.members = dictionary[@"members"];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    return @{@"title": self.title,@"description": self.description, @"currency":self.currency, @"price": self.price, @"payer_id":@(self.payerID), @"members":self.members};
}

+ (NSString *)requestPath{
    return @"expenses.json";
}
@end

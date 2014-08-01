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
    if (self = [self init]) {
        self.id = [dictionary[@"id"] integerValue];
        self.title = dictionary[@"title"];
        self.description = dictionary[@"description"];
        self.currency = dictionary[@"currency"];
        self.price = [NSNumber numberWithFloat:[dictionary[@"price"] floatValue]];
        self.debtors = [ShariUser processJSONArray:dictionary[@"debtors"]];
        self.debts = [ShariDebt processJSONArray:dictionary[@"debts"]];
        self.payer = [[ShariUser alloc] initWithRawDictionary:dictionary[@"payer"]];
    }
    return self;
}

- (NSString *) processUsers{
    NSMutableArray *userDicArray = [[NSMutableArray alloc] init];
    for (ShariUser *u in self.debtors) {
        [userDicArray addObject:[u dictionaryRepresentation]];
    }
    return [userDicArray copy];
}

- (NSDictionary *)dictionaryRepresentation{
    NSMutableArray *keys = [[NSMutableArray alloc] initWithObjects:@"title", @"description", @"event_id", @"price", nil];
    NSMutableArray *objects = [[NSMutableArray alloc] initWithObjects:self.title, self.description, @(self.event.id), self.price,  nil];
    if (self.debtors) {
        [keys addObject:@"users"];
        [objects addObject:[self processUsers]];
    }
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return [[NSDictionary alloc] initWithObjectsAndKeys:parameters, @"expense", nil];
    
}

+ (NSString *)requestPath{
    return @"expenses.json";
}


@end

@implementation ShariDebt
- (instancetype)initWithRawDictionary:(NSDictionary *)dictionary{
    if (self = [self init]){
        self.id = [dictionary[@"id"] integerValue];
        self.amount = [NSNumber numberWithFloat:[dictionary[@"amount"] floatValue]];
        self.debtor = [[ShariUser alloc] initWithRawDictionary:dictionary[@"debtor"]];
        self.creditor = [[ShariUser alloc] initWithRawDictionary:dictionary[@"creditor"]];
        self.isActual = [dictionary[@"actual"] boolValue];
    }
    return  self;
}

+ (NSString *)requestPath{
    return @"debts.json";
}
@end

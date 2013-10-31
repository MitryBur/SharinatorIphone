//
//  ShariExpense.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 23/10/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShariObject.h"

@interface ShariExpense : ShariObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *currency;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSInteger payerID;
@property (nonatomic) NSArray *members;

@end
//
//  ShariExpense.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 23/10/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShariObject.h"
#import "ShariUser.h"
#import "ShariEvent.h"
@class ShariDebt;
@interface ShariExpense : ShariObject
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *currency;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSNumber *price;
@property (nonatomic) ShariUser *payer;
@property (nonatomic) NSArray *debtors;
@property (nonatomic) NSArray *debts;
@property (nonatomic) ShariEvent *event;
@property (nonatomic) NSDate *dueDate;
@end

@interface ShariDebt : ShariObject
@property (nonatomic) NSInteger id;
@property (nonatomic) BOOL isActual;
@property (nonatomic) ShariUser *debtor;
@property (nonatomic) ShariUser *creditor;
@property (nonatomic) NSNumber *amount;
@end
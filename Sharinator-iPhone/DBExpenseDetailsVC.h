//
//  DBExpenseDetailsVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 25/10/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;
#import "ShariExpense.h"

@interface DBExpenseDetailsVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *payerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (nonatomic, strong) ShariExpense *expense;

@end

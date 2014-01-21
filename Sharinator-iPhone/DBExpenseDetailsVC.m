//
//  DBExpenseDetailsVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 25/10/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBExpenseDetailsVC.h"

@interface DBExpenseDetailsVC ()

@end

@implementation DBExpenseDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = self.expense.title;
    self.payerLabel.text = [NSString stringWithFormat:@"%@", self.expense.payer.name];
    self.priceLabel.text = [self.expense.price stringValue];
    self.currencyLabel.text = self.expense.currency;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

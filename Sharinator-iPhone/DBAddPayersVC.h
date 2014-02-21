//
//  DBAddPayersVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 21/02/14.
//  Copyright (c) 2014 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;
#import "ShariHeaders.h"
#import "ShariClient.h"


@interface DBAddPayersVC : UITableViewController<ShariClientDelegate>
@property (nonatomic, strong) ShariEvent *event;
@property (nonatomic, strong) ShariExpense *expense;

- (IBAction)save:(id)sender;
@end

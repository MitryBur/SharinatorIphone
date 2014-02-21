//
//  DBAddExpenseVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 10/01/14.
//  Copyright (c) 2014 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;
#import "DBAddMembersVC.h"
#import "DBSelectEventVC.h"
#import "ShariHeaders.h"

@interface DBAddExpenseVC : UITableViewController<DBSelectEventVCDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (strong, nonatomic) ShariEvent *event;
@property (nonatomic, strong) ShariExpense *expense;

- (IBAction)textFieldReturn:(id)sender;

@end


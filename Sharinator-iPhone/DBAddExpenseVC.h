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

@interface DBAddExpenseVC : UITableViewController<DBAddMembersVCDelegate, DBSelectEventVCDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

- (IBAction)save:(id)sender;

- (IBAction)textFieldReturn:(id)sender;

@end


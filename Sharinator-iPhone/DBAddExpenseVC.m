//
//  DBAddExpenseVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 10/01/14.
//  Copyright (c) 2014 Dmitry Burmistrov. All rights reserved.
//

#import "DBAddExpenseVC.h"
#import "ShariEvent.h"
#import "DBAddPayersVC.h"

@interface DBAddExpenseVC ()

@end

@implementation DBAddExpenseVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = @"None";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", segue.identifier);
    if ([segue.identifier isEqual: @"AddPayers"]) {
        DBAddPayersVC *addPayerVC = segue.destinationViewController;
        addPayerVC.event = self.event;
        self.expense = [[ShariExpense alloc] init];
        self.expense.title = self.titleTextField.text;
        self.expense.description = self.descriptionTextView.text;
        self.expense.price = [NSNumber numberWithFloat:[self.priceTextField.text floatValue]];
        self.expense.event = self.event;
        addPayerVC.expense = self.expense;
    }else if ([segue.identifier isEqual: @"SelectEvent"]) {
        DBSelectEventVC *selectEventVC = segue.destinationViewController;
        selectEventVC.delegate = self;
    }
}

- (IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hideKeyboard];
}
- (void)hideKeyboard{
    [self.titleTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.titleTextField becomeFirstResponder];
    }
}

#pragma mark - DBSelectEventVCDelegate
- (void)eventSelected:(ShariEvent *)event{
    NSLog(@"Event title is %@", event.title);
    self.event = event;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = self.event.title;
}

@end

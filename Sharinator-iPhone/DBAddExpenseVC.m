//
//  DBAddExpenseVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 10/01/14.
//  Copyright (c) 2014 Dmitry Burmistrov. All rights reserved.
//

#import "DBAddExpenseVC.h"
#import "ShariEvent.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", segue.identifier);
    if ([segue.identifier isEqual: @"AddMembers"]) {
        DBAddMembersVC *addMembersVC = segue.destinationViewController;
        addMembersVC.delegate = self;
    }
}

- (IBAction)save:(id)sender{
    ShariEvent *event = [[ShariEvent alloc] init];
    event.title = self.titleTextField.text;
    event.description = self.descriptionTextView.text;
    //[self.delegate addEventVCDidSave:self event:event];
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
#pragma mark - DBAddMembersToEventVCDelegate
- (void)membersAdded:(NSArray *)members{
    NSLog(@"Member IDs");
    for (NSNumber *member in members){
        NSLog(@"%d", [member integerValue]);
    }
}

@end

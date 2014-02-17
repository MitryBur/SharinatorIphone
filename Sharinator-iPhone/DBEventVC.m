//
//  DBEventVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/14/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBEventVC.h"
#import "DBMemberDetailsVC.h"
#import "DBEventInformationVC.h"
#import "DBExpenseDetailsVC.h"
#import "ShariExpense.h"
#import "ShariSocialProfile.h"

@interface DBEventVC ()

@end

@implementation DBEventVC
{
    NSArray *members;
    NSArray *expenses;
}

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
    
    self.title = self.event.title;
    members = self.event.members;
    /*ShariClient *client = [ShariClient sharedInstance];
    client.delegate = self;
    [client get:[ShariSocialProfile class]];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)visibleDataSegmentedControlChanged:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.visibleDataSegmentedControl.selectedSegmentIndex == 0) {
        return [members count];
    }
    else
        if (self.visibleDataSegmentedControl.selectedSegmentIndex == 1) {
            return [expenses count];
        }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	ShariUser *member = nil;
    ShariExpense *expense = nil;
    switch (self.visibleDataSegmentedControl.selectedSegmentIndex) {
        case 0:
            member = members[indexPath.row];
            cell.textLabel.text = member.social.name;
            cell.detailTextLabel.text = @"";
            break;
        case 1:
            expense = expenses[indexPath.row];
            cell.textLabel.text = expense.title;
            cell.detailTextLabel.text = expense.description;
            break;
        default:
            break;
    } 

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - ShariClient delegate
- (void)shariClient:(ShariClient *)client didGetWithResponse:(id)response{
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [response description]);
    
    //Any response objects are packed into array
    if ([response isKindOfClass:[NSArray class]])
    {
        if (!members)
            members = response;
        else
            expenses = response;

        [self.tableView reloadData];
        //[self.refreshControl endRefreshing];
        //return;
        
    }
    if (expenses == nil)
        [client getLocally:[ShariExpense class]];

}
- (void)shariClient:(ShariClient *)client didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (self.visibleDataSegmentedControl.selectedSegmentIndex == 0) {
        [self performSegueWithIdentifier:@"MemberDetails" sender:self];
    }
    else if (self.visibleDataSegmentedControl.selectedSegmentIndex == 1) {
        [self performSegueWithIdentifier:@"ExpenseDetails" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MemberDetails"]) {
        DBMemberDetailsVC *memberDetailsVC = segue.destinationViewController;
        memberDetailsVC.title = ((ShariSocialProfile *)members[[self.tableView indexPathForSelectedRow].row]).name;
    }
    else if ([segue.identifier isEqualToString:@"EventInfo"]){
        DBEventInformationVC *eventInfoVC = segue.destinationViewController;
        eventInfoVC.event = self.event;
    }
    else if ([segue.identifier isEqualToString:@"ExpenseDetails"]) {
        DBExpenseDetailsVC *expenseDetailsVC = segue.destinationViewController;
        expenseDetailsVC.expense = ((ShariExpense *)expenses[[self.tableView indexPathForSelectedRow].row]);
        ;
        //expenseDetailsVC.title = ((ShariExpense *)expenses[[self.tableView indexPathForSelectedRow].row]).title;
        //expenseDetailsVC.payer.text =@"Митя";
    }
}

@end

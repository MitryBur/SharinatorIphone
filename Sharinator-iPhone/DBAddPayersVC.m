//
//  DBAddPayersVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 21/02/14.
//  Copyright (c) 2014 Dmitry Burmistrov. All rights reserved.
//

#import "DBAddPayersVC.h"
#import "ShariSocialProfile.h"

@interface DBAddPayersVC ()

@end

@implementation DBAddPayersVC{
    NSMutableArray *selectedPayers;
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
    selectedPayers = [self.event.members mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.event.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ShariUser *user = self.event.members[indexPath.row];
    if ([selectedPayers containsObject:user]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = user.social.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    ShariUser *member = self.event.members[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        ShariUser *selectedMember = member;
        [selectedPayers addObject:selectedMember];
        NSLog(@"selected Payers added = %@", [selectedPayers description]);
        
    }
    else{
        [selectedPayers removeObjectIdenticalTo:member];
        NSLog(@"selected Payers removed = %@", [selectedPayers description]);

    }
}

- (IBAction)save:(id)sender {
    NSLog(@"Saved");
    ShariClient *client = [ShariClient sharedInstance];
    client.delegate = self;
    self.expense.users = [selectedPayers copy];
    [client post:[ShariExpense class] data:[self.expense dictionaryRepresentation]];
}

#pragma mark - ShariClient delegate
- (void)shariClient:(ShariClient *)client didGetWithResponse:(id)response{

}

- (void)shariClient:(ShariClient *)client didPostWithResponse:(id)response{
}

- (void)shariClient:(ShariClient *)client didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}
@end

//
//  DBAddMembersToEventVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/9/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBAddMembersToEventVC.h"
#import "ShariSocial.h"


@implementation DBAddMembersToEventVC{
    NSMutableArray *members;
    NSArray *vkFriends;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(reloadDataFromWeb) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    
    //Temp
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:recognizer];
    
    ShariClient *client = [ShariClient sharedInstance];
    client.delegate = self;
    
    members = [[NSMutableArray alloc] init];
    
    [self reloadDataFromWeb];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)swiped:(UIGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self.tableView];
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:point];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    cell.textLabel.text = @"Perfect";
    NSLog(@"Swiped");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.delegate membersAdded:[members copy]];
}

-(void)reloadDataFromWeb{
    [[ShariClient sharedInstance] getVKFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [vkFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	ShariSocial *friend = vkFriends[indexPath.row];
    cell.textLabel.text = friend.name;
    
    for (NSNumber *vkID in members) {
        if ([vkID integerValue] == friend.vkID) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[DetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    ShariSocial *friend = vkFriends[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [members addObject:@(friend.vkID)];
    }
    else{
        [members removeObjectIdenticalTo:@(friend.vkID)];
    }
}

#pragma mark - ShariClient delegate
- (void)shariClient:(ShariClient *)client didGetWithResponse:(id)response{
        vkFriends = response;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
}

- (void)shariClient:(ShariClient *)client didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}
@end

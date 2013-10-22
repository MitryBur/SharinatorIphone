//
//  DBEvents.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/6/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBEventsVC.h"
#import "ShariEvent.h"
#import "VKAccessManager.h"
#import "DBEventDetailsVC.h"

@interface DBEventsVC ()

@end

@implementation DBEventsVC
{
    BOOL flag;
    NSMutableArray *methodsQueue;
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
    
    //self.events = nil;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(reloadDataFromWeb) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    ShariClient *client = [ShariClient sharedInstance];
    client.delegate = self;
    
    methodsQueue = [[NSMutableArray alloc] init];
    VKAccessManager *vkManager = [VKAccessManager sharedInstance];
    vkManager.delegate = self;
    if (!vkManager.vkToken) {
        NSMethodSignature *signature  = [self methodSignatureForSelector:_cmd];
        NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setTarget:client];
        [invocation setSelector:@selector(authenticate)];
        
        [methodsQueue addObject:invocation];
        [vkManager refreshToken:self];
    }
    else{
        [client authenticate];
    }
}
-(void)reloadDataFromWeb{
    [[ShariClient sharedInstance] get:[ShariEvent class]];
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
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	ShariEvent *event = (self.events)[indexPath.row];
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = event.description;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", segue.identifier);

    if ([segue.identifier isEqual: @"AddEvent"]) {
        UINavigationController *naviController = segue.destinationViewController;
        DBAddEventVC *addEventVB = [naviController viewControllers][0];
        addEventVB.delegate = self;
        return;
    }
    
    if ([segue.identifier isEqual:@"EventDetails"]) {
        DBEventDetailsVC *eventDetailsVC = segue.destinationViewController;
        ShariEvent *event = (self.events)[[self.tableView indexPathForSelectedRow].row];
        eventDetailsVC.event = event;
        return;
    }
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
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#pragma mark - ShariClient delegate
- (void)shariClient:(ShariClient *)client didGetWithResponse:(id)response{

    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [response description]);
    
    //Any response objects are packed into array
    if ([response isKindOfClass:[NSArray class]])
    {
        self.events = response;
        NSLog(@"Response: %d", [self.events count]);
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        return;
    
    }
    //Except for authentication. In case of authentication request:
    [self reloadDataFromWeb];
}

- (void)shariClient:(ShariClient *)client didPostWithResponse:(id)response{
    flag = NO;
    [client get:[ShariEvent class]];
}

- (void)shariClient:(ShariClient *)client didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}

#pragma mark - DBAddEventVC delegate
- (void)addEventVCDidSave:(DBAddEventVC *)controller event:(ShariEvent *)event{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@, %@", event.title, event.description);
    [[ShariClient sharedInstance] post:[ShariEvent class] data:[event dictionaryRepresentation]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addEventVCDidCancel:(DBAddEventVC *)controller{
    NSLog(@"%s", __FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VKAccessManager delegate
- (void)vkAccessManager:(VKAccessManager *)manager tokenRefreshed:(VKAccessToken *)token{
    NSLog(@"%s", __FUNCTION__);
    if ([VKAccessToken loadToken]) {
        NSLog(@"Token: %@ %d", [VKAccessToken loadToken].token, [VKAccessToken loadToken].vkID);
    }else{
        NSLog(@"[Warning]. Token was not loaded.");
    };
    
    for (NSInvocation *i in methodsQueue){
        [i invoke];
        [methodsQueue removeObject:i];
    }
}
- (void)vkAccessManager:(VKAccessManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}

@end

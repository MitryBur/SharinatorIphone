//
//  DBEvents.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/6/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBEventsVC.h"
#import "DBEventVC.h"

#import "ShariHeaders.h"

#import "ShariAPI.h"

@interface DBEventsVC ()

@end

@implementation DBEventsVC
{
    BOOL flag;
    BOOL isAuthenticated;
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

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(reloadDataFromWeb) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    isAuthenticated = NO;
    methodsQueue = [[NSMutableArray alloc] init];
    VKAccessManager *vkManager = [VKAccessManager sharedInstance];
    vkManager.delegate = self;
    if (!vkManager.vkToken) {
        NSMethodSignature *signature  = [self methodSignatureForSelector:_cmd];
        NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setTarget:self];
        [invocation setSelector:@selector(authenticateUsingShariAPI)];
        
        [methodsQueue addObject:invocation];
        [vkManager refreshTokenFromController:self];
    }
    else{
        [self authenticateUsingShariAPI];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (isAuthenticated) {
        [self reloadDataFromWeb];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        DBEventVC *eventDetailsVC = segue.destinationViewController;
        ShariEvent *event = (self.events)[[self.tableView indexPathForSelectedRow].row];
        eventDetailsVC.event = event;
        return;
    }
}


-(void)reloadDataFromWeb{
    [ShariAPI userEventsWithSuccess:^(id response){
            NSLog(@"%s", __FUNCTION__);
            NSLog(@"%@", [response description]);
            //Any response objects are packed into array
            if ([response isKindOfClass:[NSArray class]])
            {
                self.events = response;
                NSLog(@"Response: %lu", (unsigned long)[self.events count]);
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            }
        }
     
        failure:^(NSError *error){
            [self.refreshControl endRefreshing];
            NSLog(@"%@", error);
    }];
}

- (void)authenticateUsingShariAPI
{
    [ShariAPI authenticateWithSuccess:^(id response){
        isAuthenticated = YES;
        [self reloadDataFromWeb];
    }
     
      failure:^(NSError *error){
          isAuthenticated = NO;
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Authentication failed." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
          [alert show];
          NSLog(@"Authentication failed");
      }];
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

#pragma mark - DBAddEventVC delegate
- (void)addEventVCDidSave:(DBAddEventVC *)controller event:(ShariEvent *)event{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@, %@", event.title, event.description);

    [ShariAPI addEvent:event withSuccess:^(id response){
        [self reloadDataFromWeb];
    }
        failure:^(NSError *error){
            NSLog(@"%@", error);
        }];
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
        NSLog(@"Token: %@ %lu", [VKAccessToken loadToken].token, (unsigned long)[VKAccessToken loadToken].vkID);
    }else{
        NSLog(@"[Warning]. Token was not loaded.");
    };
#warning is it really necessary?
    for (NSInvocation *i in methodsQueue){
        [i invoke];
        [methodsQueue removeObject:i];
    }
}
- (void)vkAccessManager:(VKAccessManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"VK access manager error: %@", error);
}

@end

//
//  DBSelectEventVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/9/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBSelectEventVC.h"
#import "ShariSocialProfile.h"


@implementation DBSelectEventVC{
    NSIndexPath *selectedEventIndexPath;
    NSArray *events;
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
   
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(reloadDataFromWeb) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    ShariClient *client = [ShariClient sharedInstance];
    client.delegate = self;
    
    [self reloadDataFromWeb];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ShariEvent *event = events[selectedEventIndexPath.row];
    [self.delegate eventSelected:event];
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
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	ShariEvent *event = (events)[indexPath.row];
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = event.description;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedEventIndexPath) {
        UITableViewCell *previouslySelectedCell = [tableView cellForRowAtIndexPath:selectedEventIndexPath];
        previouslySelectedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (![selectedEventIndexPath isEqual:indexPath]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedEventIndexPath = indexPath;
    }else{
        selectedEventIndexPath = nil;
    }
}

#pragma mark - ShariClient delegate
- (void)shariClient:(ShariClient *)client didGetWithResponse:(id)response{
    events = response;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)shariClient:(ShariClient *)client didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}
@end

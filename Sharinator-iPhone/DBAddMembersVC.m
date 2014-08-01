//
//  DBAddMembersVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/9/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBAddMembersVC.h"
#import "ShariSocialProfile.h"
#import "ShariUser.h"

#import "ShariAPI.h"

@implementation DBAddMembersVC{
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
   
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(reloadDataFromWeb) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    
    //Temp
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:recognizer];
    
    
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
    
    CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
    CGFloat y = cell.contentView.frame.size.height/2;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, y, size.width, 3)];
    line.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:line];
    
    
    NSLog(@"Swiped");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.delegate membersAdded:[members copy]];
}

-(void)reloadDataFromWeb{
    [ShariAPI userVKFriendsWithSuccess:^(id response){
        vkFriends = response;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
     
        failure:^(NSError *error){
            [self.refreshControl endRefreshing];
            NSLog(@"%@", error);
        }];
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

	ShariUser *friend = vkFriends[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.social.name, friend.social.surname];
    cell.accessoryType = UITableViewCellAccessoryNone;
  
    for (ShariUser *u in members) {
        if (u.social.vkID == friend.social.vkID) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    ShariUser *friend = vkFriends[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        ShariUser *user = friend;
        [members addObject:user];
    }
    else{
        [members removeObjectIdenticalTo:friend];
    }
}
@end

//
//  DBAddEventVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/8/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBAddEventVC.h"
#import "ShariSocialProfile.h"

@interface DBAddEventVC ()

@end

@implementation DBAddEventVC
{
    NSArray *eventMembers;
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
    //if ([segue.identifier isEqual: @"AddMembersToEvent"]) {
    DBAddMembersVC *addMembersVC = segue.destinationViewController;
    addMembersVC.delegate = self;
    //}
}

- (IBAction)done:(id)sender{
    ShariEvent *event = [[ShariEvent alloc] init];
    event.title = self.titleTextField.text;
    event.description = self.descriptionTextView.text;
    event.members = eventMembers;
    [self.delegate addEventVCDidSave:self event:event];
}

- (IBAction)cancel:(id)sender{
    [self.delegate addEventVCDidCancel:self];
}

- (IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hideKeyboard];
}
- (void)hideKeyboard{
    [self.titleTextField resignFirstResponder];
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
    /*for (ShariSocialProfile *member in members){
        NSLog(@"%d", member.vkID);
    }*/
    eventMembers = members;
}

@end

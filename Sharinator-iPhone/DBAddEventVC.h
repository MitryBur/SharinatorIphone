//
//  DBAddEventVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/8/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;
#import "ShariEvent.h"
#import "DBAddMembersToEventVC.h"


@protocol DBAddEventVCDelegate;

@interface DBAddEventVC : UITableViewController <DBAddMembersToEventVCDelegate>
@property (nonatomic, weak) id<DBAddEventVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)textFieldReturn:(id)sender;

@end

@protocol DBAddEventVCDelegate <NSObject>
- (void)addEventVCDidSave:(DBAddEventVC *)controller event:(ShariEvent *)event;
- (void)addEventVCDidCancel:(DBAddEventVC *)controller;
@end
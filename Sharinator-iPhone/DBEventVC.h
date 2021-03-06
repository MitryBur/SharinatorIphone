//
//  DBEventVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/14/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;

#import "ShariEvent.h"

@interface DBEventVC : UITableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *visibleDataSegmentedControl;
@property (strong, nonatomic) ShariEvent *event;

- (IBAction)visibleDataSegmentedControlChanged:(id)sender;

@end

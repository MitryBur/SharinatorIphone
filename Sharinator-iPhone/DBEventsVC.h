//
//  DBEventsVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/6/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;

#import "DBAddEventVC.h"
#import "VKAccessManager.h"

@interface DBEventsVC : UITableViewController <DBAddEventVCDelegate, VKAccessManagerDelegate>
@property (nonatomic) NSMutableArray *events;
@end

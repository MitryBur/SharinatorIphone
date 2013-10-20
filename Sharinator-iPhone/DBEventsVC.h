//
//  DBEventsVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/6/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShariClient.h"
#import "DBAddEventVC.h"
#import "VKAccessManager.h"

@interface DBEventsVC : UITableViewController <ShariClientDelegate, DBAddEventVCDelegate, VKAccessManagerDelegate>
@property (nonatomic) NSMutableArray *events;
@end

//
//  DBSelectEventVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/9/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;

#import "ShariEvent.h"

@protocol DBSelectEventVCDelegate;

@interface DBSelectEventVC : UITableViewController
@property (nonatomic, weak) id<DBSelectEventVCDelegate> delegate;
@end

@protocol DBSelectEventVCDelegate <NSObject>
- (void)eventSelected:(ShariEvent *)event;
@end
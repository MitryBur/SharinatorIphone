//
//  DBAddMembersToEventVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/9/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShariClient.h"

@protocol DBAddMembersToEventVCDelegate;

@interface DBAddMembersToEventVC : UITableViewController <ShariClientDelegate>
@property (nonatomic, weak) id<DBAddMembersToEventVCDelegate> delegate;
@end

@protocol DBAddMembersToEventVCDelegate <NSObject>
- (void)membersAdded:(NSArray *)members;
@end
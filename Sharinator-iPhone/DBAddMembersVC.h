//
//  DBAddMembersVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/9/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;

@protocol DBAddMembersVCDelegate;

@interface DBAddMembersVC : UITableViewController
@property (nonatomic, weak) id<DBAddMembersVCDelegate> delegate;
@end

@protocol DBAddMembersVCDelegate <NSObject>
- (void)membersAdded:(NSArray *)members;
@end
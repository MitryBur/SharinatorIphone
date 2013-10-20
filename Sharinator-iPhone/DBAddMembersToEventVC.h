//
//  DBAddMembersToEventVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/9/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShariClient.h"

@interface DBAddMembersToEventVC : UITableViewController <ShariClientDelegate>
@property (nonatomic, strong) NSMutableArray *vkFriends;
@end

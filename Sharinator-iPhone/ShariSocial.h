//
//  ShariSocial.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShariUser.h"

@interface ShariSocial : NSObject
//@property (nonatomic, strong) ShariUser *user;
@property (nonatomic, assign) NSInteger *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *suname;
@property (nonatomic, assign) NSInteger *vkID;

@end

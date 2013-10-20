//
//  ShariSocial.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/1/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShariObject.h"

@class ShariUser;

@interface ShariSocial : ShariObject
@property (nonatomic, strong) ShariUser *user;
@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, assign) NSInteger vkID;

@end

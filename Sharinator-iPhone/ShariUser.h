//
//  ShariUser.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 7/31/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShariObject.h"

@class ShariSocialProfile;

@interface ShariUser : ShariObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) ShariSocialProfile *social;
@end

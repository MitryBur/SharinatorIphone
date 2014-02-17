//
//  ShariEvent.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/7/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShariObject.h"
#import "ShariUser.h"

@interface ShariEvent : ShariObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) ShariUser *owner;
@property (nonatomic) NSArray *members;


@end

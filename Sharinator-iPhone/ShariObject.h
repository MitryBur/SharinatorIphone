//
//  ShariObject.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/11/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShariObject : NSObject
- (instancetype)initWithRawDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;
+ (id)processJSONString:(NSString *)string;
+ (NSArray *)processJSONArray:(NSArray *)array;
+ (NSString *)requestPath;
@end

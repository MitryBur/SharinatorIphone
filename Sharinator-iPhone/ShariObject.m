//
//  ShariObject.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 8/11/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "ShariObject.h"

@implementation ShariObject
- (instancetype)initWithRawDictionary:(NSDictionary *)dictionary{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
- (NSDictionary *)dictionaryRepresentation{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end

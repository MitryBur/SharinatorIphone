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

+ (NSArray *)processJSONArray:(NSArray *)array{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (NSDictionary *d in array) {
        [objects addObject:[[self.class alloc] initWithRawDictionary:d]];
    }
    return [objects copy];
}

- (NSDictionary *)dictionaryRepresentation{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
+ (id)processJSONString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        return [[self.class alloc] initWithRawDictionary:responseObject];
    }
    else if ([responseObject isKindOfClass:[NSArray class]]) {
        return [self.class processJSONArray:responseObject];
    }
    return nil;
}

+ (NSString *) requestPath{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
@end

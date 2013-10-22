//
//  DBDocumentsManager.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 22/10/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBDocumentsManager : NSObject
+(NSString *)applicationDocumentsDirectory;
+(void)copyFileToDocuments:(NSString *)filename;
+(NSString *)readFileFromDocuments:(NSString *)filename;
@end

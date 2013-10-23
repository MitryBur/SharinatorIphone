//
//  DBDocumentsManager.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 22/10/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBDocumentsManager.h"

@implementation DBDocumentsManager
+(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+(void)copyFileToDocuments:(NSString *)filename{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *documentsDirectory = [DBDocumentsManager applicationDocumentsDirectory];
    NSString *jsonPath = [documentsDirectory stringByAppendingPathComponent:filename];

    /*if ([fileManager fileExistsAtPath:txtPath] == NO) {
     NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"txt"];
     [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
     }
     */
    
    if ([fileManager fileExistsAtPath:jsonPath] == YES) {
        [fileManager removeItemAtPath:jsonPath error:&error];
    }
    
    NSString *fileNameNoExtension = [filename stringByDeletingPathExtension];
    NSString *extension = [filename pathExtension];
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:fileNameNoExtension ofType:extension];
    [fileManager copyItemAtPath:resourcePath toPath:jsonPath error:&error];
}

+(NSString *)readFileFromDocuments:(NSString *)filename{
    NSString *documentsDirectory = [DBDocumentsManager applicationDocumentsDirectory];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}
@end

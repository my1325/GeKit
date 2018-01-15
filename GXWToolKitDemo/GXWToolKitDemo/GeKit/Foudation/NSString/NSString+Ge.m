//
//  NSString+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "NSString+Ge.h"

@implementation NSString (Ge)

+ (NSString *)g_libraryPath {
    
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)g_tempPath {
    
    return NSTemporaryDirectory();
}

+ (NSString *)g_cachePath {
    
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)g_documentPath {
    
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

- (NSString *)g_urlEncoded {
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

- (id)g_jsonObject {
    
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

- (NSDate *)g_toDateWithFormat:(NSString *)format {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    
    return [formatter dateFromString:self];
}
@end

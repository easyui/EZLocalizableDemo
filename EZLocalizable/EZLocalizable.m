//
//  EZLocalizable.m
//  EZLocalizableDemo
//
//  Created by EZ on 14-1-2.
//  Copyright (c) 2014年 cactus. All rights reserved.
//

#import "EZLocalizable.h"

@implementation EZLocalizable

+ (NSDictionary *)localDicForAtPath:(NSString *)path
{
    if (!path) {
        return nil;
    }

    NSStringEncoding    encoding;
    NSError             *error;
    NSString            *stringsString = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:&error];

    if (!stringsString || (stringsString.length == 0)) {
        return nil;
    }

    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"[^/\\\\[ ]*]\"([ ]*[a-zA-Z0-9._]*[ ]*)\"[ ]*=[ ]*\"([ ]*.+?[ ]*)\"[ ]*;" options:NSRegularExpressionAnchorsMatchLines error:&error];
    NSArray             *matches = [regEx matchesInString:stringsString options:NSMatchingReportCompletion range:NSMakeRange(0, stringsString.length)];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:matches.count];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL *stop) {
        NSString *key = [stringsString substringWithRange:[match rangeAtIndex:1]];
        NSString *value = [stringsString substringWithRange:[match rangeAtIndex:2]];
        // 假如有相同的key后者会覆盖前者！
        [dic setObject:value forKey:key];
    }];
    return (NSDictionary *)dic;
}

@end
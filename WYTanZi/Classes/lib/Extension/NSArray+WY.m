//
//  NSArray+Extension.m
//  02-26Qz2D
//
//  Created by sialice on 16/2/27.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "NSArray+WY.h"

@implementation NSArray (WY)

+ (instancetype)wy_arryWithString:(NSString *)string divideByCharacter:(char)character
{
    // 最后字符不是分隔符则补上分隔符
    NSMutableString *str;
    if ([string characterAtIndex:string.length - 1]!= character){
        str = [NSMutableString stringWithFormat:@"%@%c", string, character];
    }else{
        str = [NSMutableString stringWithString:string];
    }
    int startIndex = 0;
    int endIndex = -1;
    NSMutableArray *arrM = [NSMutableArray array];
    // 遍历字符串
    for (int i = 0; i < str.length; i++) {
        char c = [str characterAtIndex:i];
        if (c == character) {
            startIndex = endIndex;
            endIndex = i;
            NSString *numStr = [str substringWithRange:NSMakeRange(startIndex+1, endIndex - startIndex-1)];
            [arrM addObject:numStr];
        }
    }
    return [self arrayWithArray:arrM];
    
}

// 返回数组最大值/
- (double)wy_getMaxObject
{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortedArray = [self sortedArrayUsingComparator:cmptr];
    NSNumber *number = [sortedArray lastObject];
    return number.doubleValue;
}

- (NSString *)descriptionWithLocale:(id)locale
{
    // 1.定义一个可变的字符串, 保存拼接结果
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\n"];
    // 2.迭代字典中所有的key/value, 将这些值拼接到字符串中
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")\n"];
    
    // 删除最后一个逗号
    if (self.count > 0) {
        NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
        [strM deleteCharactersInRange:range];
    }
    
    // 3.返回拼接好的字符串
    return strM;
}

@end

//
//  NSDate+WY.h
//  WY-BSBDJ
//
//  Created by sialice on 16/5/6.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WY)


/**
 *  是否是今年
 */
- (BOOL)wy_isThisYear;

/**
 *  是否当天
 */
- (BOOL)wy_isToday;

/**
 *  是否是昨天
 */
- (BOOL)wy_isYesterday;

@end

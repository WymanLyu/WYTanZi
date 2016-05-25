//
//  WYWebBar.h
//  WYTanZi
//
//  Created by sialice on 16/5/25.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYWebBar : UIView

+ (instancetype)webBar;
+ (instancetype)webBarWithBackClick:(void(^)(UIButton *backBtn))backClick;

/** 消失 */
- (void)dismiss;

/** 弹出 */
- (void)show;

/** 去死吧 */
- (void)dead;

@end

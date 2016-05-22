//
//  WYTransionBar.h
//  WYTanZi
//
//  Created by sialice on 16/5/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYTransionBar : UIView

/** 获取转场bar */
+ (instancetype)transitionBar;

/** 消失 */
- (void)dismiss;

/** 弹出 */
- (void)show;

@end

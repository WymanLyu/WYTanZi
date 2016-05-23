//
//  PingTransition.h
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <pop/POP.h>

@interface PingTransition : NSObject<UIViewControllerAnimatedTransitioning>

/** 需要做动画的按钮 */
@property (nonatomic, weak) UIButton *clickedBtn;
@end

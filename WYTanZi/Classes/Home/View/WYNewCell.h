//
//  WYNewCell.h
//  WYTanZi
//
//  Created by sialice on 16/5/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYNewModel;
@interface WYNewCell : UITableViewCell

/** 模型 */
@property (nonatomic, strong) WYNewModel *model;

/** 初始化 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end



//
//  WYNewCell.m
//  WYTanZi
//
//  Created by sialice on 16/5/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYNewCell.h"
#import "WYNewModel.h"

@interface WYNewCell ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *title;

/** 话题 */
@property (weak, nonatomic) IBOutlet UILabel *topic;

/** 点击数 */
@property (weak, nonatomic) IBOutlet UILabel *clicks;

@end

@implementation WYNewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 从xib加载cell返回
    WYNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WYNewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(WYNewModel *)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[model.midPicUrl firstObject]]];
    self.title.text = model.title;
    self.clicks.text = [NSString stringWithFormat:@"%d", model.clicks];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

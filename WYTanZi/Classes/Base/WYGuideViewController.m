//
//  WYGuideViewController.m
//  WYTanZi
//
//  Created by sialice on 16/5/21.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYGuideViewController.h"
#import "WYBaseNavigationViewController.h"
#import "WYHomeViewController.h"


#define adImageUrl @"http:\/\/mobile2.itanzi.com\/wps\/wp-content\/uploads\/2016\/05\/2016-05-20_03-14-59.jpg"
#define adUrl @"http:www.cdsb.com"

@interface WYGuideViewController ()

/** 广告图片 */
@property (nonatomic, weak) UIImageView *adImgView;

/** 动画图片 */
@property (nonatomic, weak) UIImageView *animateImgView;


@end

@implementation WYGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置子控件
    [self setupSubs];
    
    // 2.布局子控件
    [self layoutSubs];
    
    // 3.进入主界面
    [self turnToMainVc];
}

// 设置子控件
- (void)setupSubs {
    // 广告
    UIImageView *adImgView = [[UIImageView alloc] init];
    [self.view addSubview:adImgView];
    self.adImgView = adImgView;
    [self.adImgView sd_setImageWithURL:[NSURL URLWithString:adImageUrl]];
    adImgView.backgroundColor = [UIColor wy_randomColor];
    adImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [adImgView addGestureRecognizer:tap];
    
    // 动画
    UIImageView *animateImgView = [[UIImageView alloc] init];
    [self.view addSubview:animateImgView];
    self.animateImgView = animateImgView;
    [animateImgView setContentMode:UIViewContentModeCenter];
    animateImgView.clipsToBounds = YES; // 防止图片超出

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"launch_down.gif" withExtension:nil];
    [self.animateImgView sd_setImageWithURL:url];
    animateImgView.backgroundColor = [UIColor whiteColor];
}

// 布局子控件
- (void)layoutSubs {
    // 广告
    [self.adImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.7);
    }];
    
    // 动画
    [self.animateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.adImgView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
}

// 跳转主界面
- (void)turnToMainVc {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 跳转
        WYHomeViewController *homeVc = [[WYHomeViewController alloc] init];
        WYBaseNavigationViewController *baseVc = [[WYBaseNavigationViewController alloc] initWithRootViewController:homeVc];
        
        self.view.window.rootViewController = baseVc;
        
    });
}

- (void)tap{
    WYLog(@"%s", __func__);
    // 跳转官网
    UIApplication *shareApplication = [UIApplication sharedApplication];
    if ([shareApplication canOpenURL:[NSURL URLWithString:adUrl]]) {
        [shareApplication openURL:[NSURL URLWithString:adUrl]];
    };
   
}

@end





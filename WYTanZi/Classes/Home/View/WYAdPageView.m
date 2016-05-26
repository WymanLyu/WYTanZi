//
//  WYAdPageView.m
//  WYTanZi
//
//  Created by sialice on 16/5/25.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYAdPageView.h"

@interface WYAdPageView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *adView;
@property (nonatomic, weak) UILabel *lbl;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WYAdPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置子控件
        [self setupSub];
        
        // 定时器
        [self setupTimer];
    }
    return self;
}

- (void)setupSub {
    // uiscroller
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.adView = scrollView;
    
    // 布局
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
    }];
    
    // 布局adView的内容
    self.adView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
    self.adView.pagingEnabled = YES;
    self.adView.delegate = self;
    
    
    // uilable
    UILabel *lbl = [[UILabel alloc] init];
    [self addSubview:lbl];
    self.lbl = lbl;
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
        make.height.equalTo(@64);
    }];
    
    // 设置
    lbl.numberOfLines = 0;
    lbl.font = [UIFont systemFontOfSize:17.0];
    lbl.textColor = [UIColor whiteColor];
}

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

static int page = 0;
- (void)autoScroll {
    if (page == 3) {
        page = 0;
    }
    
    [self.adView setContentOffset:CGPointMake((page*[UIScreen mainScreen].bounds.size.width), 0) animated:YES];
    page++;
}

- (void)setImgArr:(NSArray<UIImage *> *)imgArr {
    _imgArr = imgArr;
    
    // imgaeView
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.backgroundColor = [UIColor wy_randomColor];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.image = imgArr[i];
        [self.adView addSubview:imgView];
        
        // 添加约束
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self); // 此处不能以父控件为标准?
            make.top.equalTo(self);
            make.left.equalTo(self.adView.mas_left).offset(i*[UIScreen mainScreen].bounds.size.width);
//            make.leftMargin.equalTo(@(i*[UIScreen mainScreen].bounds.size.width));
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        }];
        
        // 设置内容
        self.lbl.text = [NSString stringWithFormat:@"这个是滚动图片，其网络编号是：%zd，翻滚吧图片轮播器。。", i];
    }

    [self setNeedsLayout];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setupTimer];
}









@end

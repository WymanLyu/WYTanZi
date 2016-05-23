//
//  WYTransionBar.m
//  WYTanZi
//
//  Created by sialice on 16/5/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYTransionBar.h"

@interface WYWindow : UIWindow

@end
@interface WYTransionBarController : UIViewController

@end

static WYWindow *_window;

@implementation WYTransionBarController
- (void)loadView {
    // 加载view
    WYTransionBar *bar = [[NSBundle mainBundle] loadNibNamed:@"WYTransionBar" owner:self options:nil].lastObject;
    self.view = bar;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
 
    self.view.frame = frame;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WYLog(@"%@", touches.anyObject);
}


@end

@interface WYTransionBar ()

/** block */
@property (nonatomic, copy) void(^mineClick)(UIButton *mineBtn);
@property (nonatomic, copy) void(^moreClick)(UIButton *moreBtn);

@end


@implementation WYTransionBar

+ (instancetype)transitionBar{
    
    // 创建window
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width, 64);
        WYWindow *window = [[WYWindow alloc] initWithFrame:frame];
        window.windowLevel = UIWindowLevelNormal;
        window.hidden = NO; // 这个坑爹的属性
        window.rootViewController = [[WYTransionBarController alloc] init];
        
        _window = window;
    });
    
    return (WYTransionBar *)_window.rootViewController.view;
}

+ (instancetype)transitionBarWithMineClick:(void(^)(UIButton *mineBtn))mineClick moreClick:(void(^)(UIButton *moreBtn))moreClick {
    WYTransionBar *bar = [self transitionBar];
    bar.mineClick = mineClick;
    bar.moreClick = moreClick;
    return bar;
}


/** 我的按钮点击 */
- (IBAction)mineClick:(UIButton *)btn {
    self.mineClick(btn);
}

/** 更多按钮点击 */
- (IBAction)moreClick:(UIButton *)btn {
    self.moreClick(btn);
}


- (void)dismiss {
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _window.wy_top = [UIScreen mainScreen].bounds.size.height;
    } completion:nil];
}

- (void)show {
    [UIView animateWithDuration:0.35f delay:0.001 usingSpringWithDamping:0.65 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _window.wy_top = [UIScreen mainScreen].bounds.size.height - 80;
    } completion:nil];
}

@end




@implementation WYWindow

// 拦截触摸事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 仅当事件在按钮上才处理
    BOOL isHandle = CGRectContainsPoint(CGRectMake(15, 0, 50, 80), point) || CGRectContainsPoint(CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 50, 80), point);
    if (!isHandle) return nil;

    return [super hitTest:point withEvent:event];

}

@end





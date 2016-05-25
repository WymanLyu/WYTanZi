//
//  WYWebBar.m
//  WYTanZi
//
//  Created by sialice on 16/5/25.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYWebBar.h"

@interface WYWebWindow : UIWindow

@end
@interface WYWebBarController : UIViewController

@end

static WYWebWindow *_window;

@implementation WYWebBarController
- (void)loadView {
    // 加载view
    WYWebBar *bar = [[NSBundle mainBundle] loadNibNamed:@"WYWebBar" owner:self options:nil].lastObject;
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

@interface WYWebBar ()

/** block */
@property (nonatomic, copy) void(^backClick)(UIButton *backBtn);

@end


@implementation WYWebBar

+ (instancetype)webBar{
    
    // 创建window
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width, 64);
        WYWebWindow *window = [[WYWebWindow alloc] initWithFrame:frame];
        window.windowLevel = UIWindowLevelNormal;
        window.hidden = NO; // 这个坑爹的属性
        window.rootViewController = [[WYWebBarController alloc] init];
        
        _window = window;
    });
    
    return (WYWebBar *)_window.rootViewController.view;
}

+ (instancetype)webBarWithBackClick:(void(^)(UIButton *backBtn))backClick {
    WYWebBar *bar = [self webBar];
    bar.backClick = backClick;
    return bar;
}

- (void)dead {
    _window.alpha = 0.001;
}


/** 我的按钮点击 */

- (IBAction)backClick:(id)sender {
    self.backClick(sender);
}

- (IBAction)commitClick:(id)sender {
    
}

- (IBAction)favoriteClick:(id)sender {
    
}

- (IBAction)shareClick:(id)sender {
    
}



- (void)dismiss {
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _window.wy_top = [UIScreen mainScreen].bounds.size.height;
    } completion:nil];
}

- (void)show {
    _window.alpha = 1.0;
    [UIView animateWithDuration:0.35f delay:0.001 usingSpringWithDamping:0.65 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _window.wy_top = [UIScreen mainScreen].bounds.size.height - 80;
    } completion:nil];
}

@end

@implementation WYWebWindow

// 拦截触摸事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 仅当事件在按钮上才处理
    BOOL isHandle = CGRectContainsPoint(CGRectMake(15, 0, 50, 80), point) || CGRectContainsPoint(CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 50, 80), point);
    if (!isHandle) return nil;
    
    return [super hitTest:point withEvent:event];
    
}

- (void)setHidden:(BOOL)hidden {
    if (hidden) { // 隐藏则取消交互
        _window.alpha = 0.001;
    }else {
        _window.alpha = 1.0;
    }
    
    
    [super setHidden:hidden];
}



@end
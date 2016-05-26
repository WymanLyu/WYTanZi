//
//  SecondViewController.m
//  KYPingTransition
//
//  Created by Kitten Yang on 1/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "WYMineViewController.h"
#import "PingInvertTransition.h"
#import "WYHomeViewController.h"
#import "WYSettingViewController.h"

@interface WYMineViewController ()<UINavigationControllerDelegate>
/** 记录原来的nav代理 */
@property (nonatomic, weak) id<UINavigationControllerDelegate> originDelegate;

@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation WYMineViewController{
    
    UIPercentDrivenInteractiveTransition *percentTransition;
}

- (void)loadView {
    self.view = [[NSBundle mainBundle] loadNibNamed:@"WYMineViewController" owner:self options:nil].lastObject;
    self.view.frame = [UIScreen mainScreen].bounds;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:edgeGes];
   
}

// 设置
- (IBAction)settingClick:(id)sender {
    WYSettingViewController *settingVc = [[WYSettingViewController alloc] init];
    settingVc.title= @"设置";
    settingVc.view.backgroundColor = [UIColor wy_randomColor];
//    self.navigationController.navigationBarHidden = NO;
    self.navigationController.delegate = nil;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:settingVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return percentTransition;
}

- (IBAction)popVc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per =  [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, -per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (per > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(WYHomeViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *pingInvert = [PingInvertTransition new];
        pingInvert.clickedBtn = toVC.transitionBtn;
        return pingInvert;
    }else{
        return nil;
    }
}

//- (IBAction)popClicked:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end

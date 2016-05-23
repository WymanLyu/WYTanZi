//
//  SecondViewController.m
//  KYPingTransition
//
//  Created by Kitten Yang on 1/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "WYBannerViewController.h"
#import "PingInvertTransition.h"
//#import "WYBannerViewController.h"
#import "WYHomeViewController.h"

@interface WYBannerViewController ()<UINavigationControllerDelegate>
/** 记录原来的nav代理 */
@property (nonatomic, weak) id<UINavigationControllerDelegate> originDelegate;

@end

@implementation WYBannerViewController{
    
    UIPercentDrivenInteractiveTransition *percentTransition;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.originDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = self.originDelegate;
    self.originDelegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"dismiss" forState:UIControlStateNormal];
    [button sizeToFit];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(clickToPop:) forControlEvents:UIControlEventTouchUpInside];
    self.button = button;
    self.view.backgroundColor = [UIColor wy_randomColor];
    
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return percentTransition;
}

- (void)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
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

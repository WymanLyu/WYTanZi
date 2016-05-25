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

@interface WYBannerViewController ()<UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
/** 记录原来的nav代理 */
@property (nonatomic, weak) id<UINavigationControllerDelegate> originDelegate;

@property (weak, nonatomic) IBOutlet UIButton *button;

/** collectionView*/
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;

@end

@implementation WYBannerViewController{
    
    UIPercentDrivenInteractiveTransition *percentTransition;
}

- (void)loadView {
    self.view = [[NSBundle mainBundle] loadNibNamed:@"WYBannerViewController" owner:self options:nil].lastObject;
    self.view.frame = [UIScreen mainScreen].bounds;
    // 注册
    [self.collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    // 刷新 (为了布局)
    [self.collectView reloadData];
    // 布局
    [self.view layoutIfNeeded];
    // 设置列间距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectView.collectionViewLayout;
    layout.minimumLineSpacing = (self.collectView.bounds.size.height - 5 * layout.itemSize.height) / 4;
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

- (IBAction)popVc:(UIButton *)sender {
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

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor wy_randomColor];
    return cell;
}

@end

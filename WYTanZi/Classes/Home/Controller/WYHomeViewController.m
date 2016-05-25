//
//  WYHomeViewController.m
//  WYTanZi
//
//  Created by sialice on 16/5/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

// 加载更多：http://www.cdsb.mobi/cdsb/app/ios/pacong/pcgd/1
#import "WYHomeViewController.h"
#import "WYNewModel.h"
#import "WYNewCell.h"
#import "WYTransionBar.h"
#import "WYBannerViewController.h"
#import "WYMineViewController.h"
#import "PingTransition.h"
#import "WYDetailWebViewController.h"
#import "WYAdPageView.h"
#import "VideoPlayView.h"


#define HomeUrl @"http://www.cdsb.mobi/cdsb/app/ios/pacong"
#define MoreUrl @"http://www.cdsb.mobi/cdsb/app/ios/pacong/pcgd/"
#define VideoUrl @"http://120.25.226.186:32812/resources/videos/minion_01.mp4"

@interface WYHomeViewController ()<UINavigationControllerDelegate>

/** 模型分组 */
@property (nonatomic, strong) NSArray *section;

/** 页数 */
@property (nonatomic, assign) NSInteger page;

/** 悬浮bar */
@property (nonatomic, weak) WYTransionBar *transitionBar;

/** 记录原来的nav代理 */
@property (nonatomic, weak) id<UINavigationControllerDelegate> originDelegate;

/** 详情界面控制器 */
@property (nonatomic, strong) WYDetailWebViewController *webVc;

@end

@implementation WYHomeViewController

#pragma  mark - 系统回调
// 创建tableView
- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.view = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化页码
    self.page = 0;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 1.设置轮播图
    [self setupAdView];
    
    // 2.设置转场按钮
    [self setupTransitionBtn];
    
    // 3.请求数据
    [self loadData];
    
    // 4.上拉刷新
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.originDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [WYTransionBar transitionBar].hidden = NO;
    [self bigAnimateWithView:self.transitionBtn];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [WYTransionBar transitionBar].hidden = YES;
    self.navigationController.delegate = self.originDelegate;
    self.originDelegate = nil;
}

#pragma  mark - 懒加载
- (NSArray *)section {
    if (!_section) {
        _section = [NSArray array];
    }
    
    return _section;
}

- (WYDetailWebViewController *)webVc {
    if (!_webVc) {
        _webVc = [[WYDetailWebViewController alloc] init];
    }
    return _webVc;
}

#pragma mark - 设置轮播图
- (void)setupAdView {
//    UIView *view = [[UIView alloc] init];
//    view.wy_height = 200;
//    view.backgroundColor = [UIColor orangeColor];
//    self.tableView.tableHeaderView = view;
//    self.view.backgroundColor = [UIColor blackColor];
    WYAdPageView *adView = [[WYAdPageView alloc] init];
    adView.wy_height = 200;
    
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"ad%d", i + 1]];
        [mutableArr addObject:img];
    }
    adView.imgArr = mutableArr;
    self.tableView.tableHeaderView = adView;
}

#pragma mark - 设置转场按钮
- (void)setupTransitionBtn {
    // 创建bar
    WYTransionBar *bar = [WYTransionBar transitionBarWithMineClick:^(UIButton *mineBtn) {
        // 我的按钮点击
        [self smallAnimateWithView:mineBtn finishBlock:^{
            self.transitionBtn = mineBtn;
            [WYTransionBar transitionBar].hidden = YES;
            WYMineViewController *vc = [[WYMineViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    } moreClick:^(UIButton *moreBtn) {
        // 更多按钮点击
        [self smallAnimateWithView:moreBtn finishBlock:^{
            [WYTransionBar transitionBar].hidden = YES;
            self.transitionBtn = moreBtn;
            WYBannerViewController *vc = [[WYBannerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
    
    // 设置尺寸
    self.transitionBar = bar;
}

- (void)smallAnimateWithView:(UIView *)view finishBlock:(void(^)())finishBlock {
    [UIView animateWithDuration:0.25f animations:^{
        // 缩放
        view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        finishBlock();
    }];
}

- (void)bigAnimateWithView:(UIView *)view {
    [UIView animateWithDuration:0.25f delay:0.0f usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 复位
        view.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}


#pragma mark - 设置刷新控件
- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据
        [self loadData];
    }];
    UIImageView *imgView = [[UIImageView alloc]init];
    // 模拟图片
    self.tableView.mj_header.wy_height += 60;
    imgView.frame = self.tableView.mj_header.bounds;
    [imgView setImage:[UIImage imageNamed:@"Snip20160522_1"]];
    [self.tableView.mj_header addSubview:imgView];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载更多
        [self loadMoreDataWithPage:++self.page];
    }];
    // 默认隐藏
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - 加载数据
- (void)loadData {
    // 1.弹窗
    [SVProgressHUD show];
    
    // 2.请求数据
    [[WYNetTool shareNetTool] requestWithType:WYNetToolTypeGET urlString:HomeUrl parameters:nil success:^(id resultData) {
        [SVProgressHUD dismiss];
        // 1.转模型
        NSMutableArray *news1 = [WYNewModel mj_objectArrayWithKeyValuesArray:resultData[@"contentColumns"][0][@"content"]];
         NSMutableArray *news2 = [WYNewModel mj_objectArrayWithKeyValuesArray:resultData[@"contentColumns"][1][@"content"]];
        
        self.section = @[news1, news2];
        
        // 2.刷新表格
        [self.tableView reloadData];
        
        // 3.刷新页数
        self.page = 0;
        [self.tableView.mj_header endRefreshing];
        
        // 4.显示底部刷新
        self.tableView.mj_footer.hidden = NO;
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络貌似有问题..."];
        [self.tableView.mj_header endRefreshing];
    }];
}

// 加载更多数据
- (void)loadMoreDataWithPage:(NSInteger)page {
    // 2.请求数据
    NSString *url = [NSString stringWithFormat:@"%@%zd",MoreUrl, page];
    [[WYNetTool shareNetTool] requestWithType:WYNetToolTypeGET urlString:url parameters:nil success:^(id resultData) {
        [SVProgressHUD dismiss];
        // 1.转模型
        NSMutableArray *news = [WYNewModel mj_objectArrayWithKeyValuesArray:resultData[@"content"]];
//        [self.section addObject:news1];
        NSMutableArray *originNews = [self.section lastObject];
        [originNews addObjectsFromArray:news];
        
        // 2.刷新表格
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络貌似有问题..."];
        self.page--;
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *news = self.section[section];
    return news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    WYNewCell *cell = [WYNewCell cellWithTableView:tableView];
    
    // 2.设置模型
    WYNewModel *new = self.section[indexPath.section][indexPath.row];
    cell.model = new;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.section.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.transitionBar.hidden = YES;
    self.navigationController.delegate = self.originDelegate;
    WYNewModel *new = self.section[indexPath.section][indexPath.row];
    WYDetailWebViewController *detailVc = [[WYDetailWebViewController alloc] init];
    detailVc.model = new;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 0) return nil;
    VideoPlayView *playerView = [VideoPlayView videoPlayView];
    playerView.urlString = VideoUrl;
    playerView.contrainerViewController = self;
//    UIView *playerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 350)];
//    playerView.backgroundColor = [UIColor redColor];
    return playerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != 0) return 0;
    return 180;
}


// 向上滚则消失
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ((*targetContentOffset).y < 0) return; // 下拉刷新是不做动画
    if ((*targetContentOffset).y > self.tableView.contentOffset.y) { // 向上滑动
        [self.transitionBar dismiss];
    }else {
        [self.transitionBar show];
    }
}

// 开始减速就显示
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.transitionBar show];
}

// 设置透明度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = -scrollView.contentOffset.y / self.tableView.mj_header.wy_height;
    self.tableView.mj_header.alpha = scale;
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        PingTransition *ping = [PingTransition new];
        ping.clickedBtn = self.transitionBtn;
        return ping;
    }else{
        return nil;
    }
}

@end

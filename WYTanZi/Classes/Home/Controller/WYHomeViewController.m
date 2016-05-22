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


#define HomeUrl @"http://www.cdsb.mobi/cdsb/app/ios/pacong"
#define MoreUrl @"http://www.cdsb.mobi/cdsb/app/ios/pacong/pcgd/"

@interface WYHomeViewController ()

/** 模型分组 */
@property (nonatomic, strong) NSArray *section;

/** 页数 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation WYHomeViewController

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

#pragma  mark - 懒加载
- (NSArray *)section {
    if (!_section) {
        _section = [NSArray array];
    }
    
    return _section;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 1.设置轮播图
    UIView *view = [[UIView alloc] init];
    view.wy_height = 200;
    view.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = view;
    self.view.backgroundColor = [UIColor blackColor];
    
    // 2.请求数据
    [self loadData];
    
    // 3.上拉刷新
    [self setupRefresh];
}

// 设置刷新控件
- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载更多
        [self loadMoreDataWithPage:++self.page];
    }];
    // 默认隐藏
    self.tableView.mj_footer.hidden = YES;
}

// 加载数据
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






@end

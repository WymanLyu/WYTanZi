//
//  WYDetailWebViewController.m
//  WYTanZi
//
//  Created by sialice on 16/5/24.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYDetailWebViewController.h"
#import "WYNewModel.h"
#import "WYWebBar.h"

#define BaseUrl @"http://www.cdsb.mobi/cdsb/app/ios/articledetail/"

@interface WYDetailWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

@property (nonatomic, strong) WYWebBar *webBar;


@end

@implementation WYDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.detailWebView.delegate = self;
    
    // 正文
    NSString *contentStr = [NSString stringWithFormat:@"%@%zd", BaseUrl, self.model.newsId];
    [self.detailWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:contentStr]]];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.webBar) {
        // 创建工具栏
        WYWebBar *bar = [WYWebBar webBarWithBackClick:^(UIButton *backBtn) {
            // 如果不能返回则pop
            if (![self.detailWebView canGoBack]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self.detailWebView goBack];
            }
        }];
        self.webBar = bar;
    }
    self.webBar.window.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.webBar.window.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"正在加载..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"网络貌似有问题..."];
}

@end

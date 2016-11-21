//
//  WKWebViewController.m
//  XUIPhone
//
//  Created by xiaoyu on 16/5/30.
//  Copyright © 2016年 guoda. All rights reserved.
//

#import "WKWebViewController.h"
//#import "GD_HeaderCenter.h"

#import <WebKit/WebKit.h>
//#import "SelectedReloadView.h"

@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate>
{
//    SelectedReloadView *_productYear_ReloadView;//重新加载按钮

}
@property (nonatomic, weak) UIButton * backItem;

@property (nonatomic, weak) UIButton * closeItem;

@property (nonatomic) WKWebView *gdwebView;

@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation WKWebViewController
- (void)dealloc {
    if (_gdwebView) {
        [_gdwebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_gdwebView setNavigationDelegate:nil];
        [_gdwebView setUIDelegate:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createWebViewNavigation];
    [self setnavigation];
    _gdwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _gdwebView.UIDelegate = self;
    _gdwebView.navigationDelegate = self;
    [self.view addSubview:_gdwebView];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 2)];
    [self.view addSubview:_progressView];
    
    [_gdwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    NSString *str = [NSString stringWithFormat:@"http://%@",self.h5_urlString];
    NSString *url = [self encodeToPercentEscapeString:str];
    
    [_gdwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
}
- (void)setnavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavAlpha0"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    img.image = [UIImage imageNamed:@"navbgview"];
    [self.view addSubview:img];
    
}
//WKNavigationDelegate
/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
//    NSLog(@"%s", __FUNCTION__);
}
/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
//    NSLog(@"%s", __FUNCTION__);
}
/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    NSLog(@"%s", __FUNCTION__);
    NSLog(@"加载成功");
    [_progressView setProgress:0.0 animated:false];
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
//    NSLog(@"%s", __FUNCTION__);
    NSLog(@"加载失败");
//    [self webViewReloadView];
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
//    NSLog(@"%s", __FUNCTION__);
}
#if 0
#pragma mark - 重新加载界面
- (void)webViewReloadView {
    
    _productYear_ReloadView = [[SelectedReloadView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _productYear_ReloadView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    _productYear_ReloadView.gd_delegate = self;
    [self.view addSubview:_productYear_ReloadView];
}
#pragma mark - 重新加载按钮代理
- (void)didClickeReloaddButton:(UIButton *)sender{
    [_productYear_ReloadView removeFromSuperview];
    _productYear_ReloadView = nil;
    NSString *url = [self encodeToPercentEscapeString:self.h5_urlString];
    [_gdwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}
#endif

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _gdwebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_gdwebView.estimatedProgress animated:YES];
        if(_gdwebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)createWebViewNavigation {

    self.navigationItem.title = _titleName;

    UIButton * backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 20)];
    [backItem setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backItem addTarget:self action:@selector(clickedBackItem:) forControlEvents:UIControlEventTouchUpInside];
    self.backItem = backItem;
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:backItem];
    
    UIButton * closeItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeItem setTitle:@"关闭" forState:UIControlStateNormal];
    [closeItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeItem addTarget:self action:@selector(clickedCloseItem:) forControlEvents:UIControlEventTouchUpInside];
    closeItem.hidden = YES;
    self.closeItem = closeItem;
    UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc] initWithCustomView:closeItem];
    self.navigationItem.leftBarButtonItems = @[leftItem1,leftItem2];

}
#pragma mark - clickedBackItem
- (void)clickedBackItem:(UIBarButtonItem *)btn{
    if (self.gdwebView.canGoBack) {
        [self.gdwebView goBack];
        self.closeItem.hidden = NO;
    }else{
        [self clickedCloseItem:nil];
    }
}

#pragma mark - clickedCloseItem
- (void)clickedCloseItem:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)returnToVC:(UIButton*)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - url编码
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    return [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------<ios8-----------------------


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

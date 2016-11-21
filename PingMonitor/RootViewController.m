//
//  RootViewController.m
//  PingMonitor
//
//  Created by X-Designer on 16/11/21.
//  Copyright © 2016年 Guoda. All rights reserved.
//

#import "RootViewController.h"
#import "STDPingServices.h"
//#import "CircularProgressBar.h"
#import "WKWebViewController.h"
#import "MBProgressHUD.h"
#import "LHCircleView/lhCircleView.h"
#import "GDFadeView.h"
@interface RootViewController ()
{
    BOOL isCalculate;
    NSTimer *_successTimer;
    NSInteger time_Number;
}
@property(nonatomic, strong) STDPingServices    *pingServices;
@property (nonatomic, strong) UIButton *domainNameButton;   //域名名称显示及切换按钮
@property (nonatomic, assign) double now_time;
@property (nonatomic, strong) UIButton *loginButton; //登录按钮
@property (nonatomic, strong) UILabel *netStatusLabel;//网络状态
@property (nonatomic, strong) UILabel *netSpeed;//网络ping

//@property (nonatomic,strong) CircularProgressBar *gd_bar;
@property (nonatomic, strong) lhCircleView *circleView;

@property (nonatomic, strong) UIView *backgroundloadingView;
@property (nonatomic, strong) UIView *loadingView; //加载
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *labelactivity;

@property (nonatomic, strong) NSMutableArray *dataArray;//存储数据


@end

@implementation RootViewController
- (void)dealloc {
    [self.pingServices cancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setnavigation];
    self.title = @"登录器";
    _dataArray = [NSMutableArray array];
    isCalculate = YES;
    
    GDFadeView *iphoneFade = [[GDFadeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    iphoneFade.text = @"伟易博";
    iphoneFade.foreColor = [UIColor redColor];
    iphoneFade.backColor = [UIColor grayColor];
    iphoneFade.font = [UIFont systemFontOfSize:39];
    iphoneFade.alignment = NSTextAlignmentCenter;
    iphoneFade.center = CGPointMake(SCREEN_WIDTH/2, 64+100);
    [self.view addSubview:iphoneFade];
    [iphoneFade iPhoneFadeWithDuration:2];

    
    //域名更换按钮www.sina.com.cn
    [self.domainNameButton setTitle:@"www.baidu.com" forState:UIControlStateNormal];//设置默认域名
    [self.domainNameButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
  
    
    
    self.circleView = [[lhCircleView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.circleView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+100);
    [self.view addSubview:self.circleView];
    
    _netStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200-80, 200, 15)];
    _netStatusLabel.text = @"正在尝试，请稍等";
    _netStatusLabel.textAlignment = NSTextAlignmentCenter;
    _netStatusLabel.textColor = [UIColor grayColor];
    _netStatusLabel.font = [UIFont systemFontOfSize:9];
    [self.circleView addSubview:_netStatusLabel];
    
    _netSpeed = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_netStatusLabel.frame)+7, 200, 15)];
    _netSpeed.textAlignment = NSTextAlignmentCenter;
    _netSpeed.textColor = [UIColor grayColor];
    _netSpeed.font = [UIFont systemFontOfSize:9];
    [self.circleView addSubview:_netSpeed];
    
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton.frame = self.circleView.bounds;
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginButton setTitle:@"不可用" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.circleView addSubview:_loginButton];
}
- (void)loginButtonClick:(UIButton *)sender {
    
    WKWebViewController *wkweb = [[WKWebViewController alloc] init];
    wkweb.h5_urlString = self.domainNameButton.titleLabel.text;
    [self.navigationController pushViewController:wkweb animated:YES];
    
}
#pragma mark - 计算进度，更新动画
- (void)updateProgressAndStartAnimations {
    
    //计算前五次的平均
    double sum = 0;
    for (int i=0; i<_dataArray.count; i++) {
        NSString *str = _dataArray[i];
        double number = str.doubleValue;
        sum += number;
    }
    double aver = sum/5;
    double circleProgress = 0;
    if (aver>0&&aver<=50) {
        circleProgress = ((1-aver/50)*0.25) + 0.75;
        _netStatusLabel.text = [NSString stringWithFormat:@"网络良好"];
        _netSpeed.text = [NSString stringWithFormat:@"%.2f ms",aver];
        [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        _circleView.progressColor = [UIColor greenColor];
        _loginButton.userInteractionEnabled = YES;

    }else if (aver>50&&aver<100){
        circleProgress = 0.75-(aver-50)/50*0.25;
        _netStatusLabel.text = [NSString stringWithFormat:@"网络一般"];
        _netSpeed.text = [NSString stringWithFormat:@"%.2f ms",aver];
        [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        _circleView.progressColor = [UIColor orangeColor];
        _loginButton.userInteractionEnabled = YES;

    }else if (aver>100&&aver<300){
        circleProgress = 0.5-(aver-100)/200*0.4;
        _netStatusLabel.text = [NSString stringWithFormat:@"网络缓慢"];
        _netSpeed.text = [NSString stringWithFormat:@"%.2f ms",aver];
        [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        _circleView.progressColor = [UIColor redColor];
        _loginButton.userInteractionEnabled = YES;

    }else{
        circleProgress = 0;
        _netStatusLabel.text = @"当前网络请求超时";
        _netSpeed.text = @"";
        [_loginButton setTitle:@"不可用" forState:UIControlStateNormal];
        self.circleView.progressColor = [UIColor clearColor];
        _loginButton.userInteractionEnabled = NO;

    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2 animations:^{
        weakSelf.circleView.progressValue = circleProgress;
    }];
    
}
#pragma Mark - 存储前五次数据
- (void)addDataArray{
    
    if (_dataArray.count <6) {
        [_dataArray addObject:[NSString stringWithFormat:@"%.3f",_now_time]];
    }else if(_dataArray.count == 6){
        if (isCalculate) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissLoadingView];
//            [self performSelector:@selector(updateProgressAndStartAnimations) withObject:nil afterDelay:0.5];
            [self updateProgressAndStartAnimations];
            isCalculate = NO;
            
        }
    }
    
    
}
- (void)Ping_Error {
    _netStatusLabel.text = @"当前网络错误";
    _netSpeed.text = @"";
    [_loginButton setTitle:@"不可用" forState:UIControlStateNormal];
    _loginButton.userInteractionEnabled = NO;
    [self dismissLoadingView];
    [_dataArray removeAllObjects];

}
#pragma mark - 开始监控
- (void)getTimeMilliSeconds {
    isCalculate = YES;
    __weak typeof(self) weakSelf = self;
    self.pingServices = [STDPingServices startPingAddress:self.domainNameButton.titleLabel.text callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        BOOL error_bool = NO;
        if (pingItem.status != STDPingStatusFinished) {
            switch (pingItem.status) {
                case STDPingStatusDidStart:
                    //开始
                    break;
                case STDPingStatusDidReceivePacket:
                    _now_time = pingItem.timeMilliseconds;
                    break;
                case STDPingStatusDidTimeout:
                    _now_time = 301;//400的时候都是不可用
                    NSLog(@"timeout");
                    break;
                case STDPingStatusDidFailToSendPacket:
                    _now_time = 301;NSLog(@"faild");
                    break;
                case STDPingStatusDidReceiveUnexpectedPacket:
                    _now_time = 301;NSLog(@"unexpected");
                    break;
                case STDPingStatusError:
                    _now_time = 301;NSLog(@"error");
                    error_bool = YES;
                    break;
                default:
                    break;
            }
        }
        if (!error_bool) {
            [weakSelf addDataArray];
        }else{
            [weakSelf Ping_Error];
        }
    }];
    
}

- (void)btnClick:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置站点" message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入网址";
        textField.text = @"www.";
    }];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield = alertController.textFields.firstObject;
        if ([textfield.text length]>4) {
            NSLog(@"---%@=",textfield.text);
            //监测ping
            [weakSelf.domainNameButton setTitle:textfield.text forState:UIControlStateNormal];
            //start
            [weakSelf.pingServices cancel];
            weakSelf.netStatusLabel.text = @"正在尝试，请稍等";
            weakSelf.netSpeed.text = @"";
            [weakSelf.loginButton setTitle:@"不可用" forState:UIControlStateNormal];
            
            weakSelf.circleView.progressValue = 0;
            weakSelf.circleView.progressColor = [UIColor clearColor];
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [weakSelf loading5seconds];
            [weakSelf.dataArray removeAllObjects];
            [weakSelf getTimeMilliSeconds];
        }
    }];
    [alertController addAction:sureBtn];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (UIButton *)domainNameButton{
    
    if (_domainNameButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 150, 40);
        button.center = CGPointMake(SCREEN_WIDTH/2, 64+100 + 100);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 20;
        button.clipsToBounds = YES;
        [button setBackgroundImage:[self createImageWithColor:XUIColor(0x3b5286, 1)] forState:UIControlStateNormal];
        [button setBackgroundImage:[self createImageWithColor:XUIColor(0x3b5286, 0.75)] forState:UIControlStateHighlighted];

        _domainNameButton = button;
        [self.view addSubview:button];
    }
    return _domainNameButton;
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self loading5seconds];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isCalculate = YES;
    
    [self getTimeMilliSeconds];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 根据颜色创建图片
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)setnavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavAlpha0"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    img.image = [UIImage imageNamed:@"navbgview"];
    [self.view addSubview:img];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)loading5seconds{
    
    _backgroundloadingView = [[UIView alloc]initWithFrame:self.view.bounds];
    _backgroundloadingView.backgroundColor = XUIColor(0x000000, 0.4);
    [self.view addSubview:_backgroundloadingView];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 140)];
    _loadingView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _loadingView.backgroundColor = XUIColor(0x000000, 0.95);
    _loadingView.layer.cornerRadius = 8;
    _loadingView.clipsToBounds = YES;
    [_backgroundloadingView addSubview:_loadingView];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activity.center = CGPointMake(_loadingView.frame.size.width/2, _loadingView.frame.size.height/2-20);
    [_loadingView addSubview:_activity];
    [_activity startAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    label.text = @"正在加载...";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.center = CGPointMake(120, _loadingView.frame.size.height/2+20);
    [_loadingView addSubview:label];
    
    
    _labelactivity = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    _labelactivity.text = @"5s";
    _labelactivity.textColor = [UIColor whiteColor];
    _labelactivity.center = CGPointMake(60, _loadingView.frame.size.height/2+20);
    [_loadingView addSubview:_labelactivity];
    
    time_Number = 4;
    
    _successTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(animationStart) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_successTimer forMode:NSRunLoopCommonModes];
    

}
- (void)animationStart {
    
    _labelactivity.text = [NSString stringWithFormat:@"%lds",time_Number--];
    if (time_Number < 0) {
        [_successTimer invalidate];
    }
    
}
- (void)dismissLoadingView{
    [UIView animateWithDuration:0.5 animations:^{
        _activity.alpha = 0;
        _loadingView.alpha = 0;
        _backgroundloadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [_activity removeFromSuperview];_activity = nil;
        [_loadingView removeFromSuperview];_loadingView = nil;
        [_labelactivity removeFromSuperview];_labelactivity = nil;
        [_backgroundloadingView removeFromSuperview];
        _backgroundloadingView = nil;
    }];
    
    
}
@end

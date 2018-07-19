//
//  LoadingViewController.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/14.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "LoadingViewController.h"
#import "Header.h"
#import "LoadingUserView.h"
#import "Single.h"
#import "CustomProgressView.h"
#import "ExercisesViewController.h"

@interface LoadingViewController ()
@property (nonatomic, strong) NSTimer *lunxunTimer;
@property (nonatomic, strong) CustomProgressView *progressView;
@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor colorWithHex:@"#330760"];
    [self cteateTimer];
    [self createUI];
     [self performSelectorInBackground:@selector(multiThread1) withObject:nil];
}
- (void)cteateTimer{
    // 创建定时器
    NSTimer *lunxunTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(lunxun:) userInfo:nil repeats:YES];
    self.lunxunTimer = lunxunTimer;
    // 将定时器添加到runloop中，否则定时器不会启动
    [[NSRunLoop mainRunLoop] addTimer:self.lunxunTimer forMode:NSRunLoopCommonModes];
}
- (void)updateProgress{
    self.progressView.progressFloat += 0.1;
    if (self.progressView.progressFloat >= 1) {
        ExercisesViewController *exerVC = [[ExercisesViewController alloc] init];
        exerVC.roomId = self.roomId;
         exerVC.ruleId = self.ruleId;
        exerVC.leftNum = self.leftNum;
        exerVC.rightNum = self.rightNum;
        [self presentViewController:exerVC animated:YES completion:nil];
    }
}

-(void)multiThread1{
    if (![NSThread isMainThread]) {
        //此种方式创建的timer没有添加至runloop中
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        //将定时器添加到runloop中
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"多线程结束");
    }
}
//子线程
- (void)timerAction{
    //定时器也是在中执行的
    if (![NSThread isMainThread])
    {
        NSLog(@"子线程");
        // 回调主线程
        [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:YES];
    }
}
- (void)mainThread
{
    self.progressView.progressFloat += 0.3;
    if (self.progressView.progressFloat >= 1) {
    }
}

- (void)lunxun:(NSTimer *)sender{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dict = @{
                           @"roomNum":self.roomId,
                           @"TokenZZKH":[Single sharedInstance].token
                           };

    [manager GET:[NSString stringWithFormat:@"%@/websocket/get",APPHostT] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--%@--",dict);
        if ([dict[@"res"][@"messageType"] isEqualToString:@"loadingStart"]) {
            self.allTime = dict[@"data"][@"countdown"];
            ///用NSObject的方法创建一个多线程
//            [self performSelectorInBackground:@selector(multiThread1) withObject:nil];
        }else if ([dict[@"res"][@"messageType"] isEqualToString:@"game"]){
            
        }else if ([dict[@"res"][@"messageType"] isEqualToString:@"loadingEnd"]){
            ExercisesViewController *exerVC = [[ExercisesViewController alloc] init];
            exerVC.roomId = self.roomId;
             exerVC.ruleId = self.ruleId;
            exerVC.leftNum = self.leftNum;
            exerVC.rightNum = self.rightNum;
            [self presentViewController:exerVC animated:YES completion:nil];
            
        }else if ([dict[@"res"][@"messageType"] isEqualToString:@"question"]){
            ExercisesViewController *exerVC = [[ExercisesViewController alloc] init];
            exerVC.roomId = self.roomId;
            exerVC.ruleId = self.ruleId;
            exerVC.leftNum = self.leftNum;
            exerVC.rightNum = self.rightNum;
            exerVC.tittleStr = dict[@"res"][@"data"][@"title"];
            exerVC.totelNum = dict[@"res"][@"data"][@"total"];
            exerVC.optionArr = dict[@"res"][@"data"][@"options"];
            exerVC.blackaCrd = dict[@"res"][@"data"][@"blackCard"];
            exerVC.awardPool = dict[@"res"][@"data"][@"awardPool"];
            exerVC.currentNum = dict[@"res"][@"data"][@"currentNum"];
            exerVC.countdown = [dict[@"res"][@"data"][@"countdown"] intValue];
            [self presentViewController:exerVC animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}

- (void)createUI{

    //背景view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, Width, Height-60)];
    [self.view addSubview:bgView];
    for (int i =0; i<2; i++) {
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width/2, Width-60)];
        if (i == 0) {
            bgImageView.image = [UIImage imageNamed:@"色块左"];
        }else{
            bgImageView.image = [UIImage imageNamed:@"色块右"];
        }
        
        [bgView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView.mas_left).with.offset(0+(Width/2)*i);
            make.width.mas_equalTo(Width/2);
            make.height.mas_equalTo(Height-60);
        }];
    }
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"装饰logo"]];
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(320);
    }];
    
    UIImageView *textLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"字体logo"]];
    [self.view addSubview:textLogoImageView];
    [textLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"倒计时背景"]];
    [bgView addSubview:textImageView];
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom).offset(-30);
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,340, 20)];
    lab.textColor = [UIColor colorWithHex:@"#FFE348"];
    lab.text = @"本方答错 任意队员皆可帮助队友复活";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:11];
    lab.center = textImageView.center;
    [textImageView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(textImageView.mas_bottom);
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(20);
    }];
    
    
    UIImageView *jinduImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width-80, 12)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = jinduImageView.frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    UIColor *startColor = [UIColor colorWithHex:@"#3023AE"];
    UIColor *endColor = [UIColor colorWithHex:@"#C86DD7"];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@(0.2f), @(1.0f)];
    gradientLayer.cornerRadius = 6;
    [jinduImageView.layer addSublayer:gradientLayer];
    [bgView addSubview:jinduImageView];
    [jinduImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom).offset(-5);
        make.width.mas_equalTo(Width-80);
        make.height.mas_equalTo(12);
    }];
    
    //自定义progressview
    self.progressView = [[CustomProgressView alloc] initWithFrame:jinduImageView.frame];
    self.progressView.progressFloat = 0;
    [jinduImageView addSubview:self.progressView];
    
    // 对战user view
    //左方成员
    if (self.leftNum == 1) {
        NSString *isTure = @"left";
        [Single sharedInstance].str = isTure;
        
        NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
        NSLog(@"%@",NSHomeDirectory());
        //获取数据
        NSArray *arrMain = [NSArray arrayWithContentsOfFile:filePath];
        NSDictionary *dict;
        dict = arrMain[0];
        LoadingUserView *loadingUserView = [[LoadingUserView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
        if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
            loadingUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
        }else{
            loadingUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
        }
        [bgView addSubview:loadingUserView];
        [loadingUserView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.right.equalTo(logoImageView.mas_left).with.offset(-15);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(50);
        }];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        nameLab.text = dict[@"nickname"];
        nameLab.textColor = [UIColor whiteColor];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:14];
        [loadingUserView addSubview:nameLab];
    }else if (self.leftNum == 2){
        for (int i =0; i<self.leftNum; i++) {
            NSString *isTure = @"left";
            [Single sharedInstance].str = isTure;
            
            NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
            NSLog(@"%@",NSHomeDirectory());
            //获取数据
            NSArray *arrMain = [NSArray arrayWithContentsOfFile:filePath];
            NSDictionary *dict;
            if ([arrMain count]>i){
                dict = arrMain[i];
            }
            LoadingUserView *loadingUserView = [[LoadingUserView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                loadingUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                loadingUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            [bgView addSubview:loadingUserView];
            [loadingUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView.mas_centerY).offset(-70+80*i);
                make.right.equalTo(logoImageView.mas_left).with.offset(-15-(15)*i);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(50);
            }];
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
            nameLab.text = dict[@"nickname"];
            nameLab.textColor = [UIColor whiteColor];
            nameLab.textAlignment = NSTextAlignmentCenter;
            nameLab.font = [UIFont systemFontOfSize:14];
            [loadingUserView addSubview:nameLab];
        }
    }else if (self.leftNum == 3){
        for (int i =0; i<self.leftNum; i++) {
            NSString *isTure = @"left";
            [Single sharedInstance].str = isTure;
            NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
            NSLog(@"%@",NSHomeDirectory());
            //获取数据
            NSArray *arrMain = [NSArray arrayWithContentsOfFile:filePath];
            NSDictionary *dict;
            if ([arrMain count]>i){
                dict = arrMain[i];
            }
            LoadingUserView *loadingUserView = [[LoadingUserView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                loadingUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                loadingUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            [bgView addSubview:loadingUserView];
            [loadingUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView.mas_centerY).offset(-120+120*i);
                make.right.equalTo(logoImageView.mas_left).with.offset(-15-(15)*i);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(50);
            }];
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
            nameLab.text = dict[@"nickname"];
            nameLab.textColor = [UIColor whiteColor];
            nameLab.textAlignment = NSTextAlignmentCenter;
            nameLab.font = [UIFont systemFontOfSize:14];
            [loadingUserView addSubview:nameLab];
        }
        
    }else if (self.leftNum == 4){
        for (int i =0; i<self.leftNum; i++) {
            NSString *isTure = @"left";
            [Single sharedInstance].str = isTure;
            NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
            NSLog(@"%@",NSHomeDirectory());
            //获取数据
            NSArray *arrMain = [NSArray arrayWithContentsOfFile:filePath];
            NSDictionary *dict;
            if ([arrMain count]>i){
                dict = arrMain[i];
            }
            LoadingUserView *loadingUserView = [[LoadingUserView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                loadingUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                loadingUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            [bgView addSubview:loadingUserView];
            [loadingUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView.mas_centerY).offset(-180+60*i);
                make.right.equalTo(logoImageView.mas_left).with.offset(-15-(15)*i);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(50);
            }];
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
            nameLab.text = dict[@"nickname"];
            nameLab.textColor = [UIColor whiteColor];
            nameLab.textAlignment = NSTextAlignmentCenter;
            nameLab.font = [UIFont systemFontOfSize:14];
            [loadingUserView addSubview:nameLab];
        }
    }
    
    //右方成员
    if (self.rightNum == 1) {
        for (int i =0; i<self.rightNum; i++) {
            NSString *isTure = @"right";
            [Single sharedInstance].str = isTure;
            
            NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
            NSLog(@"%@",NSHomeDirectory());
            //获取数据
            NSArray *arrMain = [NSArray arrayWithContentsOfFile:filePath];
            NSDictionary *dict;
            if ([arrMain count]>i+self.leftNum){
                dict = arrMain[i+self.leftNum];
            }
            LoadingUserView *loadingUserView = [[LoadingUserView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                loadingUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                loadingUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            [bgView addSubview:loadingUserView];
            [loadingUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(logoImageView.mas_right).with.offset(15);
                make.centerY.equalTo(bgView.mas_centerY);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(50);
            }];
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, 100, 40)];
            nameLab.text = dict[@"nickname"];;
            nameLab.textColor = [UIColor whiteColor];
            nameLab.textAlignment = NSTextAlignmentCenter;
            nameLab.font = [UIFont systemFontOfSize:14];
            [loadingUserView addSubview:nameLab];
        }
    }else if (self.rightNum == 2){
        for (int i =0; i<self.rightNum; i++) {
            NSString *isTure = @"right";
            [Single sharedInstance].str = isTure;
            
            NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
            NSLog(@"%@",NSHomeDirectory());
            //获取数据
            NSArray *arrMain = [NSArray arrayWithContentsOfFile:filePath];
            NSDictionary *dict;
            if ([arrMain count]>i+self.leftNum){
                dict = arrMain[i+self.leftNum];
            }
            LoadingUserView *loadingUserView = [[LoadingUserView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                loadingUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                loadingUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            [bgView addSubview:loadingUserView];
           
            [loadingUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView.mas_centerY).offset(-70+80*i);
                make.left.equalTo(logoImageView.mas_right).with.offset(15+15*i);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(50);
            }];
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 40)];
            nameLab.text = dict[@"nickname"];;
            nameLab.textColor = [UIColor whiteColor];
            nameLab.textAlignment = NSTextAlignmentCenter;
            nameLab.font = [UIFont systemFontOfSize:14];
            [loadingUserView addSubview:nameLab];
        }
    }else if (self.rightNum == 3){
        for (int i =0; i<self.rightNum; i++) {
            NSString *isTure = @"right";
            [Single sharedInstance].str = isTure;
            
            NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
            NSLog(@"%@",NSHomeDirectory());
            //获取数据
            NSArray *arrMain = [NSArray arrayWithContentsOfFile:filePath];
            NSDictionary *dict;
            if ([arrMain count]>i+self.leftNum){
                dict = arrMain[i+self.leftNum];
            }
            LoadingUserView *loadingUserView = [[LoadingUserView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                loadingUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                loadingUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            [bgView addSubview:loadingUserView];
            [loadingUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView.mas_centerY).offset(-120+120*i);
                make.left.equalTo(logoImageView.mas_right).with.offset(15+15*i);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(50);
            }];
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 40)];
            nameLab.text = dict[@"nickname"];;
            nameLab.textColor = [UIColor whiteColor];
            nameLab.textAlignment = NSTextAlignmentCenter;
            nameLab.font = [UIFont systemFontOfSize:14];
            [loadingUserView addSubview:nameLab];
        }
    }else if (self.rightNum == 4){
        for (int i =0; i<self.rightNum; i++) {
            NSString *isTure = @"right";
            [Single sharedInstance].str = isTure;
            
            NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
            NSLog(@"%@",NSHomeDirectory());
            //获取数据
            
            NSArray *arrMain = [NSArray arrayWithContentsOfFile:filePath];
            NSDictionary *dict;
            if ([arrMain count]>i+self.leftNum){
                dict = arrMain[i+self.leftNum];
            }
            LoadingUserView *loadingUserView = [[LoadingUserView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                loadingUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                loadingUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            [bgView addSubview:loadingUserView];
            [loadingUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView.mas_centerY).offset(-180+60*i);
                make.left.equalTo(logoImageView.mas_right).with.offset(15+15*i);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(50);
            }];
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 40)];
            nameLab.text = dict[@"nickname"];;
            nameLab.textColor = [UIColor whiteColor];
            nameLab.textAlignment = NSTextAlignmentCenter;
            nameLab.font = [UIFont systemFontOfSize:14];
            [loadingUserView addSubview:nameLab];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.lunxunTimer invalidate];
    self.lunxunTimer = nil;
}
//支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}
//
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

//一开始的方向  很重要--
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}
@end

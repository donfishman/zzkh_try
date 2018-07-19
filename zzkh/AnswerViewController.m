//
//  AnswerViewController.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/11.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "AnswerViewController.h"
#import "WXApi.h"
#import "Header.h"
#import "WXApiObject.h"
#import "UserImageView.h"
#import "HeadView.h"
#import "BettalView.h"
#import "CustomAlertView.h"
#import "LoadingViewController.h"
#import "ExercisesViewController.h"
#import "BackBtn.h"

@interface AnswerViewController ()<UIScrollViewDelegate,UIApplicationDelegate>
@property (nonatomic, strong) UIButton *beforeBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, copy) NSString *indexId;

@property (nonatomic, strong) NSTimer *lunxunTimer;
@property (nonatomic, strong) NSTimer *daijishiTimer;
@property (nonatomic, copy) NSString *loadingTime;//加载时间

@property (nonatomic, strong) BettalView *bettalView;
//用户信息
@property (nonatomic, copy) NSString *nickname;//用户别名
@property (nonatomic, copy) NSString *iconStr;//用户图片
@property (assign) int position;//用户位置
@property (nonatomic, copy) NSString *userId;//用户id

@property (nonatomic, strong) NSArray *dataArr; //用户data

@property (nonatomic, strong) UILabel *startlab; //倒计时lab

@property (nonatomic, strong) UILabel *roomNumLab;  //局号

@property (assign) int startTime; //倒计时

@property (nonatomic, strong) UIView *fengeView; //分隔线

@property (nonatomic, strong) LGAudioPlayer *audioPlayer;

//++++++新加+++++++
@property(nonatomic,strong) HeadView *headView;
@end

@implementation AnswerViewController
- (void) viewWillAppear:(BOOL)animated
 {
    [super viewWillAppear:animated];
 }

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusReadyToPlay) {
                if (weakSelf.audioPlayer.isLocalFile) {
                } else {
                    //网络
                    NSLog(@"duration %f",duration);
                }
                
            } else {
                if (status == AVPlayerItemStatusFailed) {
                    
                    NSLog(@"音频播放失败，请重试");
                }
                if (weakSelf.audioPlayer.isLocalFile) {
                } else {
                    //网络音频
                }
            }
        };
        _audioPlayer.playComplete = ^{
            if (weakSelf.audioPlayer.isLocalFile) {
            } else {
                //网络
            }
        };
        _audioPlayer.playingBlock = ^(CGFloat currentTime) {
            if (weakSelf.audioPlayer.isLocalFile) {
                
            } else {
                
            }
        };
    }
    return _audioPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#330760"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, Width-40*base_W, Height-40*base_H)];
    [self.view addSubview:view];
    self.subView = view;
    [self requestJuhao];//创建开局
    [self createUI];    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabelText:) name:@"ChangeLabelTextNotification" object:nil];
}

- (void)changeLabelText:(NSNotification *)notification
{
    self.roomId = notification.object[@"roomNum"];
    self.ruleId = notification.object[@"ruleId"];
    [Single sharedInstance].token = [Single sharedInstance].token;
    self.roomNumLab.text = [NSString stringWithFormat:@"局号:%@",self.roomId];
    [self requestJuhao];//创建开局
}

- (void)cteateTimer{
    // 创建定时器
    NSTimer *lunxunTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(lunxun:) userInfo:nil repeats:YES];
    self.lunxunTimer = lunxunTimer;
    // 将定时器添加到runloop中，否则定时器不会启动
    [[NSRunLoop mainRunLoop] addTimer:self.lunxunTimer forMode:NSRunLoopCommonModes];
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
        if (![dict count]) {
            return ;
        }else{
            if ([dict[@"res"][@"messageType"] isEqualToString:@"join"]) {
                NSArray *arr = dict[@"res"][@"data"][@"members"];
                if (arr !=nil) {
                    self.dataArr = arr;
                    //写入plist文件
                    NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                        [arr writeToFile:filePath atomically:YES];
                    }else{
                        NSFileManager *manager=[NSFileManager defaultManager];
                        if ([manager removeItemAtPath:filePath error:nil]) {
                            NSLog(@"文件删除成功");
                        }
                        [arr writeToFile:filePath atomically:YES];
                    }
                }
                // 有人加入背景音乐
                NSString *urlStr = @"http://file.zzkaihei.com/zzkh/vodio/a12.mp3";
                [self.audioPlayer startPlayWithUrl:urlStr isLocalFile:NO];
                
                [self addRightView];
            }else if ([dict[@"res"][@"messageType"] isEqualToString:@"start"]){
                //房间满了之后的音效
                NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a14.mp3";
                [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
                self.startTime = [dict[@"res"][@"data"][@"countdown"] intValue];
                [self changeLab];
            }else if ([dict[@"res"][@"messageType"] isEqualToString:@"game"]){
                //            LoadingViewController *loadVC = [[LoadingViewController alloc] init];
                //            loadVC.roomId = self.roomId;
                //            loadVC.ruleId = self.ruleId;
                //            loadVC.leftNum = self.leftNum;
                //            loadVC.rightNum = self.rightNum;
                //            loadVC.userName = self.userName;
                //            [self presentViewController:loadVC animated:YES completion:nil];
            }else if ([dict[@"res"][@"messageType"] isEqualToString:@"loadingStart"]){
                LoadingViewController *loadVC = [[LoadingViewController alloc] init];
                loadVC.roomId = self.roomId;
                loadVC.ruleId = self.ruleId;
                loadVC.leftNum = self.leftNum;
                loadVC.rightNum = self.rightNum;
                loadVC.userName = self.userName;
                [self presentViewController:loadVC animated:YES completion:nil];
            }else if ([dict[@"res"][@"messageType"] isEqualToString:@"loadingEnd"]){
                
            }else{
                ExercisesViewController *exerVC = [[ExercisesViewController alloc] init];
                exerVC.roomId = self.roomId;
                exerVC.ruleId = self.ruleId;
                exerVC.leftNum = self.leftNum;
                exerVC.rightNum = self.rightNum;
                [self presentViewController:exerVC animated:YES completion:nil];
            }
        }        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}

//进入房间
- (void)requestJuhao{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dict = @{
                            @"TokenZZKH":[Single sharedInstance].token,
                            @"roomNum":self.roomId,
                            @"ruleId":self.ruleId,
                           };
    [manager POST:[NSString stringWithFormat:@"%@/websocket/init",APPHostT] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--%@--",dict);
        //轮训定时器
        [self cteateTimer];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}

- (void)createUI{
    
    _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, (405 + 17)*base_W, (45+6.5)*base_H)];
    int cardNum = [[Single sharedInstance].realCardNum intValue] - [self.needNum intValue];
    if (cardNum >= 0) {
        [Single sharedInstance].realCardNum = [NSString stringWithFormat:@"%d",cardNum];
        NSString *heiStr = [NSString stringWithFormat:@"%d",cardNum];
        NSString *heikaStr = [@"开黑卡 " stringByAppendingString:heiStr];
        _headView.heikaStr = heikaStr;
        
    }else{
        cardNum = 0;
        [Single sharedInstance].realCardNum = [NSString stringWithFormat:@"%d",cardNum];
        NSString *heiStr = [NSString stringWithFormat:@"%d",cardNum];
        NSString *heikaStr = [@"开黑卡 " stringByAppendingString:heiStr];
        _headView.heikaStr = heikaStr;
       
    }
    [_headView drawRectView];
    [self.subView addSubview:_headView];
    
    self.roomNumLab = [[UILabel alloc]init];
    self.roomNumLab.text = [NSString stringWithFormat:@"局号:%@",self.roomId];
   // self.roomNumLab.font = [UIFont systemFontOfSize:17*base_W];
    self.roomNumLab.textColor = [UIColor whiteColor];
    self.roomNumLab.textAlignment = NSTextAlignmentLeft;
    [self.subView addSubview:self.roomNumLab];
    [self.roomNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headView.mas_right).offset(10.5);
        make.width.mas_equalTo(96*base_W);
        make.centerY.mas_equalTo (_headView.mas_centerY);
        make.height.mas_equalTo (22.5*base_H);
    }];
    
    BackBtn *exitBtn = [[BackBtn alloc]init];
    UIImage *img = [UIImage imageNamed:@"退局"];
    [exitBtn setImage:img forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:20*base_W];
    exitBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [exitBtn addTarget:self action:@selector(pushaction) forControlEvents:UIControlEventTouchUpInside];
    [[exitBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];

    [self.subView addSubview:exitBtn];
    
    __weak typeof(self)weakSelf = self;
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.roomNumLab.mas_right).offset(12.5*base_W);
        make.width.mas_equalTo(90*base_W);
        make.top.mas_equalTo (weakSelf.roomNumLab.mas_top);
        make.height.mas_equalTo (weakSelf.roomNumLab);
    }];

    [self addLeftView];
    [self addRightView];
}

//  LeftView
- (void)addLeftView{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240*base_W, 280*base_H)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = leftView.frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    UIColor *startColor = [UIColor colorWithHex:@"#4F4EC1"];
    UIColor *endColor = [UIColor colorWithHex:@"#5B25AC"];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@(0.2f), @(1.0f)];
    gradientLayer.cornerRadius = 10;
    [leftView.layer addSublayer:gradientLayer];
    self.leftView = leftView;
    [self.subView addSubview:self.leftView];
    
    __weak typeof(self)weakSelf = self;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.headView.mas_bottom).offset(13*base_H);
        make.left.mas_equalTo(weakSelf.headView.mas_left);
        make.width.mas_equalTo(239*base_W);
        make.height.mas_equalTo(283.5*base_H);
    }];
    
    UILabel *tittleLab = [[UILabel alloc] init];
    tittleLab.textColor = [UIColor whiteColor];
    tittleLab.font = [UIFont systemFontOfSize:18*base_H];
    //tittleLab.textAlignment = NSTextAlignmentCenter;
    tittleLab.text = @"赞助方";
    [leftView addSubview:tittleLab];
    
    [tittleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftView.mas_top).offset(13*base_H);
        make.centerX.mas_equalTo(leftView.mas_centerX);
        make.width.mas_equalTo(60*base_W);
        make.height.mas_equalTo(28*base_H);
    }];
    
    
    
    UIImageView *tittleImageView = [[UIImageView alloc] init];
    tittleImageView.image = [UIImage imageNamed:@"标题装饰"];
    [leftView addSubview:tittleImageView];
    [tittleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tittleLab);
        make.right.mas_equalTo(tittleLab.mas_left).offset(-6.5*base_W);
        make.width.mas_equalTo(18.5*base_W);
        make.height.mas_equalTo(14*base_H);
    }];
    
    UIImageView *tittleImageView2 = [[UIImageView alloc] init];
//    tittleImageView2.backgroundColor = [UIColor orangeColor];
    tittleImageView2.image = [UIImage imageNamed:@"标题装饰"];
    [leftView addSubview:tittleImageView2];
    [tittleImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tittleLab);
        make.left.mas_equalTo(tittleLab.mas_right).offset(7.2*base_W);
        make.width.mas_equalTo(18.5*base_W);
        make.height.mas_equalTo(14*base_H);
    }];
    
    UIImageView *zanzhuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"赞助文案背景"]];
    [leftView addSubview:zanzhuImageView];
    [zanzhuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tittleLab.mas_bottom);
        make.right.mas_equalTo(leftView.mas_right).offset(-11*base_W);
        make.width.mas_equalTo(199*base_W);
        make.height.mas_equalTo(42.5*base_H);
    }];
    UILabel *zanzhuLab = [[UILabel alloc] init];
    zanzhuLab.text = [NSString stringWithFormat:@"本场由%@赞助",_zanzhuName];
    zanzhuLab.font = [UIFont systemFontOfSize:15*base_H];
    zanzhuLab.textColor = [UIColor whiteColor];
    [zanzhuImageView addSubview:zanzhuLab];
    [zanzhuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zanzhuImageView.mas_top).offset(7*base_H);
        make.left.mas_equalTo(zanzhuImageView.mas_left).offset(24*base_W);
        make.width.mas_equalTo(160.5*base_W);
        make.height.mas_equalTo(18.5*base_H);
    }];
    
    UIImageView *wanglaojiImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"王老吉"]];
    [leftView addSubview:wanglaojiImageView];
    [wanglaojiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zanzhuImageView);
        make.left.mas_equalTo(zanzhuImageView.mas_left).offset(-4.5*base_W);
        make.width.mas_equalTo(25*base_W);
        make.height.mas_equalTo(46.5*base_H);
    }];
    UILabel *jiangjinLab = [[UILabel alloc] init];
    jiangjinLab.text = [NSString stringWithFormat:@"每场最高%@元",self.topMoney];
    jiangjinLab.font = [UIFont systemFontOfSize:8*base_W];
    jiangjinLab.textColor = [UIColor blackColor];
    [zanzhuImageView addSubview:jiangjinLab];
    [jiangjinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zanzhuImageView).with.offset(10*base_H);
        make.centerX.equalTo(zanzhuImageView).with.offset(-40*base_W);
        make.width.mas_equalTo(80*base_W);
        make.height.mas_equalTo(12*base_H);
    }];
    
    //初始奖金
    UIImageView *firstView = [[UIImageView alloc] init];
//    firstView.backgroundColor = [UIColor orangeColor];
    firstView.image = [UIImage imageNamed:@"撒钱"];
    [leftView addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zanzhuImageView.mas_bottom).offset(9.5*base_H);
        make.right.equalTo(leftView.mas_right).offset(-24*base_W);
        make.width.mas_equalTo(76*base_W);
        make.height.mas_equalTo(87.5*base_H);
    }];
    UILabel *firstLab = [[UILabel alloc] init];
    firstLab.text = @"不定期撒钱";
    firstLab.textColor = [UIColor whiteColor];
    [firstView addSubview:firstLab];
    firstLab.textAlignment = NSTextAlignmentCenter;
    [firstLab setFont:[UIFont systemFontOfSize:9]];
    [firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(firstView.mas_bottom);
        make.centerX.equalTo(firstView);
        make.width.mas_equalTo(firstView);
        make.height.mas_equalTo(20*base_H);
    }];
    
    //不定期撒钱
    UIImageView *secondView = [[UIImageView alloc] init];
//    secondView.backgroundColor = [UIColor orangeColor];
    secondView.image = [UIImage imageNamed:@"开始奖金"];
    [leftView addSubview:secondView];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView);
        make.left.equalTo(leftView.mas_left).offset(25*base_W);
        make.width.mas_equalTo(76*base_W);
        make.height.mas_equalTo(87.5*base_H);
    }];
    
    UILabel *secondLab = [[UILabel alloc] init];
    secondLab.text = [NSString stringWithFormat:@"初识奖金%@元",self.startMoney];
    secondLab.textColor = [UIColor whiteColor];
    [secondView addSubview:secondLab];
    secondLab.textAlignment = NSTextAlignmentCenter;
    [secondLab setFont:[UIFont systemFontOfSize:9]];
    [secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(secondView.mas_bottom);
        make.centerX.equalTo(secondView);
        make.width.mas_equalTo(secondView);
        make.height.mas_equalTo(20*base_H);
    }];
    
    //参赛说明
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHex:@"#2D046B"];
    view.layer.cornerRadius = 7;
    [leftView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (secondLab.mas_bottom).offset(15.5*base_H);
        make.centerX.equalTo(leftView);
        make.width.mas_equalTo(leftView.bounds.size.width-40*base_W);
        make.height.mas_equalTo(75*base_H);
    }];
    
    UILabel *tellLab = [[UILabel alloc] init];
    tellLab.text = @"- 参赛说明 -";
    tellLab.numberOfLines = 0;
    tellLab.textColor = [UIColor whiteColor];
    tellLab.textAlignment = NSTextAlignmentCenter;
    [tellLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:tellLab];
    
    [tellLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(5*base_H);
        make.width.mas_equalTo(view);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.mas_equalTo(16.5*base_H);
    }];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.text = @"每题为抢答形式，本方第一个点击的选项，即为本队答案，点击之后不能更改";
    introLab.numberOfLines = 0;
    introLab.textColor = [UIColor whiteColor];
    introLab.textAlignment = NSTextAlignmentLeft;
    [introLab setFont:[UIFont systemFontOfSize:11*base_H]];
    [view addSubview:introLab];
    
    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tellLab.mas_bottom).offset(5*base_H);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.width.mas_equalTo(175.5*base_W);
        make.bottom.mas_equalTo(view.mas_bottom).offset(-5*base_H);
    }];
    
}

// RightView
- (void)addRightView{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 381*base_W, 283*base_H)];
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = rightView.frame;
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    UIColor *startColor2 = [UIColor colorWithHex:@"#4F4EC1"];
    UIColor *endColor2 = [UIColor colorWithHex:@"#5B25AC"];
    gradientLayer2.colors = @[(__bridge id)startColor2.CGColor,
                              (__bridge id)endColor2.CGColor];
    gradientLayer2.locations = @[@(0.2f), @(1.0f)];
    gradientLayer2.cornerRadius = 10;
    [rightView.layer addSublayer:gradientLayer2];
    [self.subView addSubview:rightView];
    __weak typeof(self)weakSelf = self;
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.leftView.mas_bottom);
        make.left.equalTo(weakSelf.leftView.mas_right).offset(12*base_W);
        make.width.mas_equalTo(381*base_W);
        make.height.mas_equalTo(weakSelf.leftView.mas_height);
    }];
    self.rightView = rightView;
    
    //黄色条形view
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width-285*base_W, 10*base_H)];
    yellowView.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:yellowView.bounds      byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft   cornerRadii:CGSizeMake(20*base_W, 20*base_H)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = yellowView.bounds;
    maskLayer.path = maskPath.CGPath;
    yellowView.layer.mask = maskLayer;
    [self.rightView addSubview:yellowView];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rightView.mas_top);
        make.right.mas_equalTo(rightView.mas_right);
        make.left.mas_equalTo(rightView.mas_left);
        make.height.mas_equalTo(7.5*base_H);
    }];
    
    UILabel *personLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*base_W, 20*base_H)];
    personLab.textAlignment = NSTextAlignmentLeft;
    personLab.font = [UIFont systemFontOfSize:14];
    personLab.text= [NSString stringWithFormat:@"已准备%lu/%d人",(unsigned long)self.dataArr.count,self.rightNum+self.leftNum];
    personLab.textColor = [UIColor whiteColor];
    [rightView addSubview:personLab];
    [personLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView.mas_top).offset(20*base_H);
        make.left.equalTo(rightView.mas_left).offset(20*base_W);
        make.width.mas_equalTo(100*base_W);
        make.height.mas_equalTo(20*base_H);
    }];
    //分隔线
    UIView *fengeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 140*base_H)];
    fengeView.backgroundColor = [UIColor whiteColor];
    [rightView addSubview:fengeView];
    [fengeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rightView.mas_top).offset(60.5*base_H);
        make.centerX.equalTo(weakSelf.rightView.mas_centerX);
        make.width.mas_equalTo(1*base_W);
        make.height.mas_equalTo(138*base_H);
    }];
    self.fengeView = fengeView;
    [self cteateInventLab];
    
    //要加判断
    UIImageView *betNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -8*base_W, 100*base_W, 60*base_H)];
    UIImage *bettalImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.bettalPic]]];
    betNumImageView.image = bettalImg;
    [rightView addSubview: betNumImageView];
    [betNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView.mas_top).with.offset(-10*base_H);
        make.centerX.equalTo(rightView.mas_centerX);
        make.width.mas_equalTo(100*base_W);
        make.height.mas_equalTo(65*base_H);
    }];
    
    if (self.leftNum != 0 && self.leftNum <= 2) {
         for (int i = 0; i<self.leftNum; i++) {
             BettalView *bettalView = [[BettalView alloc] initWithFrame:CGRectMake(0, 0, 50*base_W, 70*base_H)];
             if ([self.dataArr count]>i) {
                    NSURL *url = [NSURL URLWithString:self.dataArr[i][@"avatar"]];
                     bettalView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                     bettalView.nameLab.text = self.dataArr[i][@"nickname"];
             }
             [rightView addSubview:bettalView];
             [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(fengeView).offset(0+80*base_H*i);
                 make.left.equalTo(fengeView.mas_left).offset(-120*base_W);
             }];
         }
    }else if (self.leftNum != 0 && self.leftNum == 3){
        for (int i = 0; i<self.leftNum; i++) {
            BettalView *bettalView = [[BettalView alloc] initWithFrame:CGRectMake(0, 0, 50*base_W, 70*base_H)];
            if ([self.dataArr count]>i) {
                NSURL *url = [NSURL URLWithString:self.dataArr[i][@"avatar"]];
                bettalView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                bettalView.nameLab.text = self.dataArr[i][@"nickname"];
            }
            [rightView addSubview:bettalView];
            
            if (i == 0) {
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView.mas_top);
                    make.left.equalTo(rightView.mas_left).offset(80.5*base_W);
                }];
            }else if (i ==1){
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(80*base_H);
                    make.left.equalTo(rightView.mas_left).offset(113*base_W);
                }];
            }else if (i ==2){
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(80*base_H);
                    make.left.equalTo(rightView.mas_left).offset(47.5*base_W);
                }];
            }
        }
    }else if (self.leftNum != 0 && self.leftNum == 4){
            for (int i = 0; i<self.leftNum; i++) {
                BettalView *bettalView = [[BettalView alloc] initWithFrame:CGRectMake(0, 0, 50*base_W, 70*base_H)];
                if ([self.dataArr count]>i) {
                    NSURL *url = [NSURL URLWithString:self.dataArr[i][@"avatar"]];
                    bettalView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    bettalView.nameLab.text = self.dataArr[i][@"nickname"];
                }
                [rightView addSubview:bettalView];
                
                if (i == 0) {
                    [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(fengeView).offset(0);
                        make.left.equalTo(fengeView.mas_left).offset(-100*base_W);
                    }];
                }else if (i ==1){
                    [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(fengeView).offset(80*base_H);
                        make.left.equalTo(fengeView.mas_left).offset(-100*base_W);
                    }];
                }else if (i ==2){
                    [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(fengeView).offset(0);
                        make.left.equalTo(fengeView.mas_left).offset(-200*base_W);
                    }];
                }else if (i ==3){
                    [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(fengeView).offset(80*base_H);
                        make.left.equalTo(fengeView.mas_left).offset(-200*base_W);
                    }];
                }
            }
        }
    if (self.rightNum != 0 && self.rightNum <= 2) {
        for (int i = 0; i<self.rightNum; i++) {
            BettalView *bettalView = [[BettalView alloc] initWithFrame:CGRectMake(0, 0, 50*base_W, 70*base_H)];
            if ([self.dataArr count]>self.leftNum+i) {
                NSURL *url = [NSURL URLWithString:self.dataArr[i+self.leftNum][@"avatar"]];
                bettalView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                bettalView.nameLab.text = self.dataArr[i+self.leftNum][@"nickname"];
            }
            [rightView addSubview:bettalView];
            [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(fengeView).offset(0+80*base_H*i);
                make.right.equalTo(fengeView.mas_left).offset(70*base_W);
            }];
        }
    }else if (self.rightNum != 0 && self.rightNum == 3){
        for (int i = 0; i<self.leftNum; i++) {
            BettalView *bettalView = [[BettalView alloc] initWithFrame:CGRectMake(0, 0, 50*base_W, 70*base_H)];
            if ([self.dataArr count]>self.leftNum+i) {
                NSURL *url = [NSURL URLWithString:self.dataArr[i+self.leftNum][@"avatar"]];
                bettalView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                bettalView.nameLab.text = self.dataArr[i+self.leftNum][@"nickname"];
            }
            [rightView addSubview:bettalView];
            
            if (i == 0) {
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(0);
                    make.left.mas_equalTo(fengeView.mas_right).offset(72*base_W);
                }];
            }else if (i ==1){
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(80*base_H);
                    make.left.mas_equalTo(fengeView.mas_right).offset(39*base_W);
                }];
            }else if (i ==2){
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(80*base_H);
                    make.left.mas_equalTo(fengeView.mas_right).offset(104.5*base_W);
                }];
            }
        }
    }else if (self.rightNum != 0 && self.rightNum == 4){
        for (int i = 0; i<self.leftNum; i++) {
            BettalView *bettalView = [[BettalView alloc] initWithFrame:CGRectMake(0, 0, 50*base_W, 70*base_H)];
            if ([self.dataArr count]>self.leftNum) {
                NSURL *url = [NSURL URLWithString:self.dataArr[i+self.leftNum][@"avatar"]];
                bettalView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                bettalView.nameLab.text = self.dataArr[i+self.leftNum][@"nickname"];
            }
            [rightView addSubview:bettalView];
            
            if (i == 0) {
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(0);
                    make.right.equalTo(fengeView.mas_left).offset(50*base_W);
                }];
            }else if (i ==1){
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(80*base_H);
                    make.right.equalTo(fengeView.mas_left).offset(50*base_W);
                }];
            }else if (i ==2){
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(0);
                    make.right.equalTo(fengeView.mas_left).offset(150*base_W);
                }];
            }else if (i ==3){
                [bettalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fengeView).offset(80*base_H);
                    make.right.equalTo(fengeView.mas_left).offset(150*base_W);
                }];
            }
        }
    }
}

- (void )cteateInventLab{    
    UILabel *startlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 270, 40)];
    startlab.text = @"邀请好友";
    startlab.textColor = [UIColor blackColor];
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.frame = startlab.frame;
    gradientLayer3.startPoint = CGPointMake(0, 0);
    gradientLayer3.endPoint = CGPointMake(1, 0);
    UIColor *startColor3 = [UIColor colorWithHex:@"#F4F366"];
    UIColor *endColor3 = [UIColor colorWithHex:@"#FFB003"];
    gradientLayer3.colors = @[(__bridge id)startColor3.CGColor,
                              (__bridge id)endColor3.CGColor];
    gradientLayer3.locations = @[@(0.1f), @(1.0f)];
    gradientLayer3.cornerRadius = 20;
    [startlab.layer addSublayer:gradientLayer3];
    
    startlab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inventFriend:)];
    [startlab addGestureRecognizer:tap];
    startlab.textAlignment = NSTextAlignmentCenter;
    startlab.font = [UIFont systemFontOfSize:17];
    [self.rightView addSubview:startlab];
    
    [startlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.fengeView.mas_bottom).offset(25);
        make.centerX.equalTo(self.fengeView.mas_centerX);
    }];
    self.startlab = startlab;
}

- (void)changeLab{
    //移除lab
    self.daijishiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
}

- (void)action{
    NSLog(@"---%d---",self.startTime);
    self.startTime --;
    if (self.startTime <= 0) {
        self.startlab.text = [NSString stringWithFormat:@"已准备(0s)"];
    }else{
        NSLog(@"=======%d-====",self.startTime);
        self.startlab.text = [NSString stringWithFormat:@"已准备(%ds)",self.startTime-1];
    }
}

- (void)inventFriend:(UITapGestureRecognizer *)tap{
   [[NSNotificationCenter defaultCenter]postNotificationName:@"inventFriend" object:nil];
}

#pragma --mark 购买黑卡
- (void)buyCard:(UITapGestureRecognizer *)tap{
    UIView *bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Height, Width)];
    bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8/1.0];
    [self.view addSubview:bigBGview];
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110, 60, 450, 260)];
    alertView.backgroundColor = [UIColor colorWithHex:@"#FC596B"];
    alertView.bgView.image = [UIImage imageNamed:@"复活成功背景"];
    [self.view addSubview:alertView];
}

-(void)pushaction{
    //tuichu 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[Single sharedInstance].token forHTTPHeaderField:@"TokenZZKH"];
    NSDictionary *dict = @{
                           @"matchNum":self.roomId
                           };
    [manager POST:@"https://zzkh.kai-hei.com/zzkhapi/match/exitMatch" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--1111%@1111--",dict);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.audioPlayer stopPlaying];
    [self.lunxunTimer invalidate];
    [self.daijishiTimer invalidate];
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

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}
@end

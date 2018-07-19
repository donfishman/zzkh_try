//
//  ExercisesViewController.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/13.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "ExercisesViewController.h"
#import "HeadView.h"
#import "WXApi.h"
#import "Header.h"
#import "WXApiObject.h"
#import "UserView.h"
#import "PKUserView.h"
#import "CustomAlertView.h"
#import "MainViewController.h"
#import "LMJScrollTextView2.h"

@interface ExercisesViewController ()<UIApplicationDelegate,WXApiDelegate,LMJScrollTextView2Delegate>
{
    LMJScrollTextView2 * _scrollTextView;
}
@property (nonatomic, strong) UIView *quesView;

@property (nonatomic, strong) NSTimer *lunxunTimer;

@property (nonatomic, strong) UILabel *daojishiLab;

@property (nonatomic, strong) UILabel *blackLab;

@property (nonatomic , copy) NSString *tureNum;//正确的选项
@property (nonatomic , copy) NSString *ourNum;//我方的选项
@property (nonatomic , copy) NSString *ourName;//我方的名字
@property (nonatomic , copy) NSString *ourPic;//我方的图片
@property (nonatomic , copy) NSString *oppoNum;//对方的选项
@property (nonatomic , copy) NSString *oppoName;//对方的名字
@property (nonatomic , copy) NSString *oppoPic;//对方的图片

@property (nonatomic , copy) NSString *wxPay;//需要购买的卡数
@property (nonatomic , copy) NSString *fuhuoBlackCard; //消耗的黑卡数

@property (nonatomic , copy) NSString *isLeft;

@property (nonatomic , copy) NSString *userPlace;

@property (nonatomic, strong) UIButton *seleBtn;//选项btn

@property (assign) int countdown1;//撒钱倒计时
@property (assign) int countdown2;//撒钱倒计时
@property (assign) int countdown3;//撒钱倒计时
@property (assign) int countdown4;//撒钱倒计时
@property (assign) int countdown5;//撒钱倒计时
@property (assign) int countdown6;//撒钱倒计时
@property (assign) int countdown7;//撒钱倒计时
@property (assign) int countdown8;//撒钱倒计时
@property (assign) int countdown9;//撒钱倒计时
@property (assign) int countdown10;//撒钱倒计时

@property (nonatomic, strong) UILabel *timeLab1; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab2; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab3; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab4; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab5; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab6; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab7; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab8; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab9; //弹框倒计时
@property (nonatomic, strong) UILabel *timeLab10; //弹框倒计时

@property (nonatomic,strong)UILabel *juhaoLab;

@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, strong) NSTimer *timer3;
@property (nonatomic, strong) NSTimer *timer4;
@property (nonatomic, strong) NSTimer *timer5;
@property (nonatomic, strong) NSTimer *timer6;
@property (nonatomic, strong) NSTimer *timer7;
@property (nonatomic, strong) NSTimer *timer8;
@property (nonatomic, strong) NSTimer *timer9;
@property (nonatomic, strong) NSTimer *timer10;

@property (nonatomic, strong) UIView *bigBGview; //弹框背景

@property (nonatomic, strong) HeadView *headView;

@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic , strong) NSMutableArray *labaArr;
@end

@implementation ExercisesViewController{
    NSTimer *sonTimer;
    NSTimer *broTimer;
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

- (void)cteateTimer{
    // 创建定时器
    NSTimer *lunxunTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(lunxun:) userInfo:nil repeats:YES];
    self.lunxunTimer = lunxunTimer;
    // 将定时器添加到runloop中，否则定时器不会启动
    [[NSRunLoop mainRunLoop] addTimer:self.lunxunTimer forMode:NSRunLoopCommonModes];
}

//开启子线程创建定时器
-(void)multiThread{
    if (![NSThread isMainThread]) {
        //此种方式创建的timer没有添加至runloop中
        sonTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        //将定时器添加到runloop中
        [[NSRunLoop currentRunLoop] addTimer:sonTimer forMode:NSDefaultRunLoopMode];
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
        self.countdown -= 1;
        // 回调主线程
        [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:YES];
    }
}

- (void)mainThread
{
    self.daojishiLab.text=[NSString stringWithFormat:@"倒计时:%ds",self.countdown];
    if (self.countdown<=0) {
        [sonTimer invalidate];
    }
}
- (void)buyBlackCard{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[Single sharedInstance].token forHTTPHeaderField:@"TokenZZKH"];
    NSDictionary *dataDictionary = @{
                                     @"payCardNum":self.wxPay,
                                     };
    [manager POST:@"https://zzkh.kai-hei.com/zzkhapi/order/userPayOrder" parameters:dataDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--%@--",dict);
        if ([dict[@"message"] isEqualToString:@"success"]) {
            NSDictionary *dic = dict[@"res"][@"wxAppPay"];
            
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = dic[@"partnerid"];
            request.prepayId= dic[@"prepayid"];
            request.package = dic[@"package"];
            request.nonceStr= dic[@"noncestr"];
            NSString *str = dic[@"timestamp"];
            request.timeStamp= [str intValue];
            request.sign= dic[@"sign"];
            [WXApi sendReq:request];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        if (response.errCode ==  WXSuccess) {
            NSLog(@"支付成功，retcode=%d",resp.errCode);            
        }else{
            NSLog(@"支付失败，retcode=%d",resp.errCode);
        }
    }
}

- (void)GetLaBaTittle{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[Single sharedInstance].token forHTTPHeaderField:@"TokenZZKH"];
    NSDictionary *dataDictionary = @{
                                     @"type":@"2",
                                     };
    [manager POST:@"https://zzkh.zzkaihei.com/zzkhapi/ehint/getHint" parameters:dataDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--%@--",dict);
        if ([dict[@"message"] isEqualToString:@"success"]) {
            self.labaArr = [[NSMutableArray alloc] init];
            NSArray *arr = dict[@"res"][@"list"];
            for (NSDictionary *dic in arr) {
                [self.labaArr addObject:dic[@"content"]];
            }
            [self createLabaLab];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetLaBaTittle];
    [self cteateTimer];   
    self.view.backgroundColor = [UIColor colorWithHex:@"#330760"];
    NSLog(@"Width===%f,Height===%f",Width,Height);
    self.headView = [[HeadView alloc] initWithFrame:CGRectMake(30*base_W, 20*base_H, (405 + 17)*base_W, (45+6.5)*base_H)];
    NSString *heiStr = [NSString stringWithFormat:@"%@",[Single sharedInstance].realCardNum];
    NSString *heikaStr = [@"开黑卡 " stringByAppendingString:heiStr];
    self.headView.heikaStr = heikaStr;
//    self.blackLab = headView.heikaLab;
//    [headView addSubview:self.blackLab];
//    self.headView = headView;
//    UIImageView *kaiheikaImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(275, 0, 35, 35)];
//    kaiheikaImageView.image = [UIImage imageNamed:@"黑卡"];
//    [headView addSubview:kaiheikaImageView];
    [self.headView drawRectView];
    [self.view addSubview: self.headView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, Height - 100*base_H, Width, 100*base_H)];
    imageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:imageView];
    
    //局号lab
    self.juhaoLab = [[UILabel alloc] init];
    self.juhaoLab.textColor = [UIColor whiteColor];
    self.juhaoLab.text= [NSString stringWithFormat:@"局号:%@",self.roomId];
    self.juhaoLab.textAlignment = NSTextAlignmentRight;
    self.juhaoLab.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.juhaoLab];
    
    __weak typeof(self)weakSelf = self;
    [self.juhaoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(25.5*base_H);
        make.right.mas_equalTo(weakSelf.view.mas_right).mas_offset(-29*base_W);
        make.width.mas_equalTo(100*base_W);
        make.height.mas_equalTo(22.5*base_H);
    }];
    //题干view
    [self createUI];
    //添加倒计时
    [self daojishi];
    //用NSObject的方法创建一个多线程
    [self createTittleView];
    [self fuhuokaView];
    [self createQuestion];
    [self createSeleBtn:nil];
    [self createLeftAndRight];
}

//喇叭
- (void)createLabaLab{
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"倒计时背景"]];
    [self.view addSubview:textImageView];
    
    __weak typeof(self)weakSelf = self;
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.juhaoLab.mas_bottom).mas_offset(11*base_H);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20*base_W);;
        make.width.mas_equalTo(200*base_W);
        make.height.mas_equalTo(25*base_H);
    }];
    
    _scrollTextView = [[LMJScrollTextView2 alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    _scrollTextView.delegate            = self;
    _scrollTextView.textStayTime        = 1.5;
    _scrollTextView.scrollAnimationTime = 1;
    //    _scrollTextView.backgroundColor     = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
    _scrollTextView.textColor           = [UIColor colorWithHex:@"#FDE648"];
    _scrollTextView.textFont            = [UIFont boldSystemFontOfSize:11.f];
    _scrollTextView.textAlignment       = NSTextAlignmentLeft;
    _scrollTextView.touchEnable         = YES;
    _scrollTextView.layer.cornerRadius  = 3;
    
    [_scrollTextView startScrollBottomToTopWithNoSpace];
    [self.view addSubview:_scrollTextView];
    
    [_scrollTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.juhaoLab.mas_bottom).mas_offset(11*base_H);
        make.right.equalTo(weakSelf.view.mas_right).mas_offset(-10.5*base_W);
        make.width.mas_equalTo(180*base_W);
        make.height.mas_equalTo(25*base_H);
    }];
    
    if (self.labaArr.count == 0) {
        [self GetLaBaTittle];
    }else {
        _scrollTextView.textDataArr = [[NSMutableArray alloc] init];
        _scrollTextView.textDataArr = self.labaArr;
    }
    UIImageView *labaImgView = [[UIImageView alloc ]init];
    labaImgView.image = [UIImage imageNamed:@"喇叭"];
    [self.view addSubview:labaImgView];
    [labaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollTextView).with.offset(5*base_H);
        make.right.equalTo(_scrollTextView.mas_left).with.offset(-5*base_W);
        make.width.mas_equalTo(15*base_W);
        make.height.mas_equalTo(15*base_H);
    }];
}

//倒计时
- (void)daojishi{
    //倒计时lab
    self.daojishiLab = [[UILabel alloc] init];
    self.daojishiLab.backgroundColor = [UIColor colorWithHex:@"#5C1CBD"];
    self.daojishiLab.layer.cornerRadius = 10;
    self.daojishiLab.clipsToBounds = YES;
    if (self.countdown != 0) {
        self.daojishiLab.text= [NSString stringWithFormat:@"倒计时:%ds",self.countdown];
    }
    self.daojishiLab.textAlignment = NSTextAlignmentCenter;
    self.daojishiLab.textColor = [UIColor colorWithHex:@"#FFE348"];
    [self.view addSubview:self.daojishiLab];
    
    __weak typeof(self)weakSelf = self;
    [self.daojishiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.width.mas_equalTo(123.75*base_W);
        make.height.mas_equalTo(21*base_H);
    }];
  
}

- (void)createUI{
     [self performSelectorInBackground:@selector(multiThread) withObject:nil];
    self.quesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 405*base_W, 259*base_H)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.quesView.frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    UIColor *startColor = [UIColor colorWithHex:@"#4F4FC1"];
    UIColor *endColor = [UIColor colorWithHex:@"#6B2EC1"];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@(0.2f), @(1.0f)];
    gradientLayer.cornerRadius = 10;
    [self.quesView.layer addSublayer:gradientLayer];
    [self.view addSubview:self.quesView];
    
    __weak typeof(self)weakSelf = self;
    [self.quesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-15*base_H);
        make.width.mas_equalTo(405*base_W);
        make.height.mas_equalTo(259*base_H);
    }];
    
    
    //黄色条形view
    UIView *yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:yellowView.bounds      byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft   cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = yellowView.bounds;
    maskLayer.path = maskPath.CGPath;
    yellowView.layer.mask = maskLayer;
    [self.quesView addSubview:yellowView];
    
    __weak typeof(self)weakself = self;
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.quesView.mas_top);
        make.right.mas_equalTo(weakself.quesView.mas_right);
        make.width.mas_equalTo(weakself.quesView);
        make.height.mas_equalTo(6.6*base_H);
    }];
}

- (void)fuhuokaView{
    //复活所需复活卡
    UIImageView *fuhuokaImageView = [[UIImageView alloc] init];
    fuhuokaImageView.image = [UIImage imageNamed:@"倒计时背景"];
    [self.quesView addSubview:fuhuokaImageView];
    
    __weak typeof(self)weakSelf = self;
    [fuhuokaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.quesView.mas_top).offset(42.5*base_H);
        make.centerX.equalTo(weakSelf.quesView.mas_centerX);
        make.width.mas_equalTo(214*base_W);
        make.height.mas_equalTo(25*base_H);
    }];
    UILabel *fuhuokaLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 20)];
    if (![self.blackaCrd isKindOfClass:[NSNull class]] || self.blackaCrd.length) {
        fuhuokaLab.text = [NSString stringWithFormat: @"本轮复活所需黑卡:%@张",self.blackaCrd];
    }
    fuhuokaLab.textColor = [UIColor colorWithHex:@"#FFC331"];
    fuhuokaLab.textAlignment = NSTextAlignmentCenter;
    fuhuokaLab.font = [UIFont systemFontOfSize:11];
    fuhuokaLab.center = fuhuokaImageView.center;
    [fuhuokaImageView addSubview:fuhuokaLab];
    
    [fuhuokaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fuhuokaImageView);
        make.right.mas_equalTo(fuhuokaImageView);
        make.width.mas_equalTo(fuhuokaImageView);
        make.height.mas_equalTo(fuhuokaImageView);
    }];
}

- (void)createTittleView{
    //绘制题目view
    UIView *tittleView = [[UIView alloc] init];
    //    tittleView.backgroundColor = [UIColor grayColor];
    [self.quesView addSubview:tittleView];
    
    __weak typeof(self)weakSelf = self;
    [tittleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.quesView.mas_top).offset(14*base_H);
        make.centerX.equalTo(weakSelf.quesView.mas_centerX);
        make.width.mas_equalTo(200*base_W);
        make.height.mas_equalTo(25*base_H);
    }];
    UILabel *tittleLab = [[UILabel alloc] init];
    if (![self.awardPool isKindOfClass:[NSNull class]] || self.awardPool.length){
        NSString *awardPoolStr = self.awardPool;
        double awardPooll = [awardPoolStr doubleValue];
        tittleLab.text =[NSString stringWithFormat: @"奖金已累计:%.2f元",awardPooll];
    }
    tittleLab.textColor = [UIColor whiteColor];
    tittleLab.textAlignment = NSTextAlignmentCenter;
    tittleLab.font = [UIFont systemFontOfSize:17];
    [tittleView addSubview:tittleLab];
    [tittleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tittleView.mas_top);
        make.centerX.equalTo(tittleView.mas_centerX);
        make.width.mas_equalTo(156.5*base_W);
        make.height.mas_equalTo(25*base_H);
    }];
    for (int i =0; i<2; i++) {
        UIImageView *tittleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25*base_W, 25*base_H)];
        tittleImageView.image = [UIImage imageNamed:@"标题装饰"];
        [tittleView addSubview:tittleImageView];
        [tittleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tittleLab);
            make.centerX.equalTo(tittleLab).with.offset((-100+200*i)*base_W);
            make.width.mas_equalTo(25*base_W);
            make.height.mas_equalTo(20*base_H);
        }];
    }
}

- (void)createQuestion{
    //问题lab
    UILabel *quesLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 370, 70)];
    if (![self.currentNum isKindOfClass:[NSNull class]] && ![self.tittleStr isEqualToString:@""]) {
        NSString *quesNumStr = [NSString stringWithFormat:@"%@：",self.currentNum];
        quesLab.text = [NSString stringWithFormat: @"%@ %@",quesNumStr, self.tittleStr];;
    }    
    quesLab.textColor = [UIColor whiteColor];
    //    quesLab.backgroundColor = [UIColor orangeColor];
    quesLab.numberOfLines = 0;
    quesLab.textAlignment = NSTextAlignmentLeft;
    quesLab.font = [UIFont systemFontOfSize:14];
    // 根据字体得到label的内容的尺寸
    CGSize size = [quesLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:quesLab.font,NSFontAttributeName,nil]];
    CGFloat JGlabelContentHeight = size.height;
    if (JGlabelContentHeight >= 365.0) {
        JGlabelContentHeight = 365.0;
    }
    [self.quesView addSubview:quesLab];
    
    __weak typeof (self)weakSelf = self;
    [quesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.quesView.mas_bottom).offset(-134.5*base_H);
        make.left.equalTo(weakSelf.quesView.mas_left).offset(21.5*base_W);
        make.width.mas_equalTo(362.5*base_W);
        make.height.mas_equalTo(70*base_H);
    }];
}
- (void)createLeftAndRight{
    
    NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePatch stringByAppendingPathComponent:@"dataArr.plist"];
    NSLog(@"%@",NSHomeDirectory());
    //获取数据
    NSMutableArray *arrMain = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary *dict in arrMain) {
        if ([dict[@"unionId"] isEqualToString:[Single sharedInstance].unionId]) {
            self.userPlace = dict[@"position"];
            if ([dict[@"position"] intValue] >= self.leftNum) {
                
                self.isLeft = @"left";
            }else{
                self.isLeft = @"right";
            }
        }
    }

    if ([self.isLeft isEqualToString:@"left"]) {//zuo

        for (int i =0; i<self.leftNum; i++) {
            NSDictionary *dict;
            NSString *isTure = @"left";
            [Single sharedInstance].str = isTure;
            
            if ([arrMain count]>i){
                dict = arrMain[i];
            }
            PKUserView *pkUserView = [[PKUserView alloc]init];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                pkUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                pkUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            pkUserView.nameLab.text = dict[@"nickname"];
            [self.view addSubview:pkUserView];
            
            __weak typeof(self)weakSelf = self;
            [pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.quesView.mas_top).offset((10+45*i)*base_H);
                make.left.equalTo(weakSelf.view.mas_left).offset(20*base_W);
                make.width.mas_equalTo(100*base_W);
                make.height.mas_equalTo(40*base_H);
            }];
        }
        for (int i =0; i<self.rightNum; i++) {
            NSDictionary *dict;
            NSString *isTure = @"right";
            [Single sharedInstance].str = isTure;
            if ([arrMain count]>i+self.leftNum){
                dict = arrMain[i+self.leftNum];
            }
            PKUserView *pkUserView = [[PKUserView alloc]init];
            pkUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            pkUserView.nameLab.text = dict[@"nickname"];
            [self.view addSubview:pkUserView];
            
            __weak typeof(self)weakSelf = self;
            [pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.quesView.mas_top).offset((10+45*i)*base_H);
                make.left.equalTo(weakSelf.quesView.mas_right).offset(20*base_W);
                make.width.mas_equalTo(100*base_W);
                make.height.mas_equalTo(40*base_H);
            }];
        }
    }else{
        for (int i =0; i<self.rightNum; i++) {
            NSDictionary *dict;
            NSString *isTure = @"right";
            [Single sharedInstance].str = isTure;
            if ([arrMain count]>i+self.leftNum){
                dict = arrMain[i+self.leftNum];
            }
            PKUserView *pkUserView = [[PKUserView alloc]init];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                pkUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                pkUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            pkUserView.nameLab.text = dict[@"nickname"];
            [self.view addSubview:pkUserView];
            
             __weak typeof(self)weakSelf = self;
            [pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.quesView.mas_top).with.offset((10+45*i)*base_H);
                make.left.equalTo(weakSelf.quesView.mas_right).offset(20*base_W);
                make.width.mas_equalTo(100*base_W);
                make.height.mas_equalTo(40*base_H);
            }];
        }
        for (int i =0; i<self.leftNum; i++) {
            NSDictionary *dict;
            NSString *isTure = @"left";
            [Single sharedInstance].str = isTure;
            if ([arrMain count]>i){
                dict = arrMain[i];
            }
            PKUserView *pkUserView = [[PKUserView alloc]init];
            if ([dict[@"avatar"] isEqualToString:@""] || dict[@"avatar"] == nil) {
                pkUserView.smallImgView.image = [UIImage imageNamed:@"默认头像"];
            }else{
                pkUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"avatar"]]]];
            }
            pkUserView.nameLab.text = dict[@"nickname"];
            [self.view addSubview:pkUserView];
            
             __weak typeof(self)weakSelf = self;
            [pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.quesView.mas_top).with.offset((10+45*i)*base_H);
                make.left.equalTo(weakSelf.quesView.mas_right).offset(20*base_W);
                make.width.mas_equalTo(100*base_W);
                make.height.mas_equalTo(40*base_H);
            }];
        }
    }
}

- (void)createSeleBtn:(id)sender{
    for (int i =0; i<4; i++) {
        UIButton *seleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 100)];
        if (i == 0) {
            seleBtn.backgroundColor = [UIColor colorWithHex:@"#DC2287"];
        }else if (i == 1){
            seleBtn.backgroundColor = [UIColor colorWithHex:@"#EF6361"];
        }else if (i == 2){
            seleBtn.backgroundColor = [UIColor colorWithHex:@"#FFAF51"];
        }else{
            seleBtn.backgroundColor = [UIColor colorWithHex:@"#FFC92D"];
        }
        if(self.optionArr != nil && ![self.optionArr isKindOfClass:[NSNull class]] && self.optionArr.count != 0){
           [seleBtn setTitle:self.optionArr[i] forState:UIControlStateNormal];
        }        
        seleBtn.titleLabel.textColor = [UIColor whiteColor];
        seleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        seleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        seleBtn.layer.cornerRadius = 15;
        seleBtn.clipsToBounds = YES;
        seleBtn.tag = i;
        seleBtn.titleLabel.numberOfLines = 0;
        seleBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [seleBtn addTarget:self action:@selector(selector:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.tureNum intValue]-1 == i) {
            seleBtn.backgroundColor = [UIColor colorWithHex:@"#2BA94F"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8-6打勾"]];
            [seleBtn addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(seleBtn.mas_top).with.offset(10*base_H);
                make.centerX.equalTo(seleBtn.mas_centerX);
                make.width.mas_equalTo(15*base_W);
                make.height.mas_equalTo(15*base_H);
            }];
        }
        self.seleBtn = seleBtn;
        [self.quesView addSubview:self.seleBtn];
        [self.seleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.quesView.mas_bottom).offset(-19.5*base_H);
            make.left.equalTo(self.quesView.mas_left).offset((22.5+95.5*i)*base_W);
            make.width.mas_equalTo(73*base_W);
            make.height.mas_equalTo(91*base_H);
        }];
    }
}


- (void)createSeleBtn1:(id)sender{
    for (int i =0; i<4; i++) {
        UIButton *seleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 100)];
        seleBtn.backgroundColor = [UIColor colorWithHex:@"#FC596B"];
        [seleBtn setTitle:self.optionArr[i] forState:UIControlStateNormal];
        seleBtn.titleLabel.textColor = [UIColor whiteColor];
        seleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        seleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        seleBtn.layer.cornerRadius = 15;
        seleBtn.clipsToBounds = YES;
        seleBtn.tag = i;
        seleBtn.titleLabel.numberOfLines = 0;
        seleBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [seleBtn addTarget:self action:@selector(selector:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.tureNum intValue]-1 == i) {
            seleBtn.backgroundColor = [UIColor colorWithHex:@"#2BA94F"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8-6打勾"]];
            [seleBtn addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(seleBtn.mas_top).with.offset(10*base_H);
                make.centerX.equalTo(seleBtn.mas_centerX);
                make.width.mas_equalTo(15*base_W);
                make.height.mas_equalTo(15*base_H);
            }];
        }
        self.seleBtn = seleBtn;
        [self.quesView addSubview:self.seleBtn];
        [self.seleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.quesView.mas_bottom).offset(-19.5*base_H);
            make.left.equalTo(self.quesView.mas_left).offset((22.5+95.5*i)*base_W);
            make.width.mas_equalTo(73*base_W);
            make.height.mas_equalTo(91*base_H);
        }];
    }
}


#pragma 我方的选项
- (void)updataOurSelect{
    if ([self.ourNum intValue] != 0) {
        if ([self.isLeft isEqualToString:@"left"]) {
            
            NSString *isTure = @"left";
            [Single sharedInstance].str = isTure;
            PKUserView *pkUserView = [[PKUserView alloc]init];
            pkUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.ourPic]]];
            pkUserView.nameLab.text = self.ourName;
            [self.quesView addSubview:pkUserView];
            int a = [self.ourNum intValue]-1;
            [pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.quesView.mas_bottom).offset(-120);
                make.left.equalTo(self.quesView.mas_left).offset(15+95*a);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(40);
            }];
        }else{
            NSString *isTure = @"right";
            [Single sharedInstance].str = isTure;
            PKUserView *pkUserView = [[PKUserView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
            pkUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.ourPic]]];
            pkUserView.nameLab.text = self.ourName;
            [self.quesView addSubview:pkUserView];
            int a = [self.ourNum intValue]-1;
            [pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.quesView.mas_bottom).offset(-115);
                make.left.equalTo(self.quesView.mas_left).offset(15+95*a);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(40);
            }];
        }
    }
}
#pragma 对方的选项
- (void)updataOppoSelect{
    if ([self.oppoNum intValue] != 0) {
        if ([self.isLeft isEqualToString:@"left"]) {
            NSString *isTure = @"right";
            [Single sharedInstance].str = isTure;
            PKUserView *pkUserView = [[PKUserView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
            pkUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.oppoPic]]];
            pkUserView.nameLab.text = self.oppoName;
            [self.quesView addSubview:pkUserView];
            [self.quesView bringSubviewToFront:pkUserView];
            int a = [self.oppoNum intValue]-1;
            [pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.quesView.mas_bottom).offset(-35);
                make.left.equalTo(self.quesView.mas_left).offset(15+95*a);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(40);
            }];
        }else{
            NSString *isTure = @"left";
            [Single sharedInstance].str = isTure;
            PKUserView *pkUserView = [[PKUserView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
            pkUserView.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.oppoPic]]];
            pkUserView.nameLab.text = self.oppoName;
            [self.quesView addSubview:pkUserView];
            int a = [self.oppoNum intValue]-1;
            [pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.quesView.mas_bottom).offset(-35);
                make.left.equalTo(self.quesView.mas_left).offset(15+95*a);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(40);
            }];
        }
    }
}

- (void)selector:(UIButton *)sender{
    //提交答案
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dataDictionary = @{
                                     @"selectIndex":[NSString stringWithFormat:@"%ld",(long)sender.tag+1],
                                     @"currentNum":self.currentNum,
                                     @"TokenZZKH":[Single sharedInstance].token,
                                     @"ruleId":self.ruleId,
                                     @"roomNum":self.roomId,
                                     @"messageType":@"mineSelect"
                                     };
    [manager POST:[NSString stringWithFormat:@"%@/websocket/send",APPHostT] parameters:dataDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"提交答案成功--%@--",dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
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
         if ([dict[@"res"][@"messageType"] isEqualToString:@"getAnswer"]) {
             
             self.tureNum = nil;
             self.oppoName = nil;
             self.ourName = nil;
             self.ourPic = nil;
             self.oppoPic = nil;
             self.ourNum = nil;
             self.oppoNum = nil;
             
            self.tureNum = dict[@"res"][@"data"][@"rightSelect"];
            self.ourName = dict[@"res"][@"data"][@"selectInfo"][@"our"][@"nickname"];
            self.ourPic = dict[@"res"][@"data"][@"selectInfo"][@"our"][@"avatar"];
            self.ourNum = dict[@"res"][@"data"][@"selectInfo"][@"our"][@"selectIndex"];
             
             self.oppoNum = dict[@"res"][@"data"][@"selectInfo"][@"opposite"][@"selectIndex"];
             self.oppoName = dict[@"res"][@"data"][@"selectInfo"][@"opposite"][@"nickname"];
             self.oppoPic = dict[@"res"][@"data"][@"selectInfo"][@"opposite"][@"avatar"];

             [self createSeleBtn1:nil];
             [self updataOurSelect];
             [self updataOppoSelect];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"select"]){
             NSLog(@"++%@--",dict[@"res"][@"data"][@"selectIndex"]);
             self.ourNum = dict[@"res"][@"data"][@"selectIndex"];
             self.ourPic = dict[@"res"][@"data"][@"avatar"];
             self.ourName = dict[@"res"][@"data"][@"nickname"];
            [self updataOurSelect];
             
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"pay"]){
             self.wxPay = dict[@"res"][@"data"][@"wxPay"];
             [self buyBlackCard];
             
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"question"]){
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             NSLog(@"++%@--",dict[@"res"][@"data"][@"title"]);
             self.tittleStr = dict[@"res"][@"data"][@"title"];
             self.optionArr = dict[@"res"][@"data"][@"options"];
             self.blackaCrd = dict[@"res"][@"data"][@"blackCard"];
             self.awardPool = dict[@"res"][@"data"][@"awardPool"];
             self.currentNum = dict[@"res"][@"data"][@"currentNum"];
             self.totelNum = dict[@"res"][@"data"][@"total"];
             self.countdown = [dict[@"res"][@"data"][@"countdown"] intValue];
             //添加倒计时
             self.tureNum = nil;
             [self createUI];
             [self daojishi];
             [self createTittleView];
             [self fuhuokaView];
             [self createQuestion];
             [self createSeleBtn:nil];
             
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"bonus"]){
             //撒币
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //撒钱
             NSString *urlStr = @"http://file.zzkaihei.com/zzkh/vodio/a13.mp3";
            [self.audioPlayer startPlayWithUrl:urlStr isLocalFile:NO];
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110, 50, Width-220, Height-70)];
             
             //渐变色
             UIView *bibiview = [[UIView alloc] initWithFrame:CGRectMake(0, 3,  Width-220, 30)];
             CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
             gradientLayer2.frame = bibiview.frame;
             gradientLayer2.startPoint = CGPointMake(0, 0);
             gradientLayer2.endPoint = CGPointMake(0, 1);
             UIColor *startColor2 = [UIColor colorWithHex:@"#FFE348"];
             UIColor *endColor2 = [UIColor colorWithHex:@"#F65E66"];
             gradientLayer2.colors = @[(__bridge id)startColor2.CGColor,
                                       (__bridge id)endColor2.CGColor];
             gradientLayer2.locations = @[@(0.1f), @(1.0f)];
             gradientLayer2.cornerRadius = 10;
             [bibiview.layer addSublayer:gradientLayer2];
             [cusView addSubview:bibiview];
             
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#F65E66"];
             cusView.bgView.image = [UIImage imageNamed:@"撒钱背景光芒"];
             UIImageView *mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 160,100)];
             mainView.center = cusView.bgView.center;
             mainView.image = [UIImage imageNamed:@"撒钱插画"];
             [cusView.bgView addSubview:mainView];
             [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(160*base_W);
                 make.height.mas_equalTo(100*base_H);
                 make.centerX.equalTo(cusView.bgView.mas_centerX);
                 make.centerY.equalTo(cusView.bgView.mas_centerY).offset(-30*base_H);
             }];
             
             UIImageView *zanzhushangImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 350, 60)];
             zanzhushangImgView.image = [UIImage imageNamed:@"撒钱标题"];
             [bibiview addSubview:zanzhushangImgView];
             [zanzhushangImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(350*base_W);
                 make.height.mas_equalTo(60*base_H);
                 make.centerX.equalTo(bibiview.mas_centerX);
                 make.top.equalTo(bibiview.mas_top).offset(0);
             }];
             
             cusView.samllView.image = [UIImage imageNamed:@""];
             cusView.tittleLab.text = @"";
             self.timeLab1 = cusView.timeLab;
             self.timeLab1.text = [NSString stringWithFormat:@"%@s",dict[@"res"][@"data"][@"countdown"]];
             
             //开启倒计时
             self.countdown1 = [dict[@"res"][@"data"][@"countdown"] intValue];
             self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread1) userInfo:nil repeats:YES];
             //富文本
             NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本轮王老吉撒钱助兴:%@元",dict[@"res"][@"data"][@"bonus"]]];
             [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0]range:NSMakeRange(0, 10)];//设置字体
             cusView.mainLab.textColor = [UIColor colorWithHex:@"#FFE348"];
             cusView.mainLab.font = [UIFont systemFontOfSize:21];
             [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 10)];
             cusView.mainLab.attributedText = aStr;
             
             
             //富文本2
             NSString *introStr = dict[@"res"][@"data"][@"awardPool"];
             double introMoney = [introStr doubleValue];
             NSMutableAttributedString *poolStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总奖金池已达:%.2f元",introMoney]];
             [poolStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0]range:NSMakeRange(0, 7)];//设置字体
             cusView.introLab.textColor = [UIColor colorWithHex:@"#FFE348"];
             cusView.introLab.font = [UIFont systemFontOfSize:21];
             [poolStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 7)];
             cusView.introLab.attributedText = poolStr;
             
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
             
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"save"]){
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //等待复活
             NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a9.mp3";
             [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#694CF2"];
             cusView.bgView.image = [UIImage imageNamed:@"复活选择背景2"];
             UIImageView *picImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140*base_W, 100*base_H)];
             picImgView.image= [UIImage imageNamed:@"选择复活插画"];
             [cusView addSubview:picImgView];
             [picImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(140*base_W);
                 make.height.mas_equalTo(100*base_H);
                 make.centerX.equalTo(cusView.mas_centerX);
                 make.centerY.equalTo(cusView.mas_centerY).offset(-30*base_H);
             }];
             self.timeLab2 = cusView.timeLab;
             cusView.tittleLab.text = [NSString stringWithFormat:@"%@回答错误 是否复活",dict[@"res"][@"data"][@"nickname"]];
             self.timeLab2.text = [NSString stringWithFormat:@"%@s",dict[@"res"][@"data"][@"countdown"]];
             self.fuhuoBlackCard = dict[@"res"][@"data"][@"blackCard"];
             
             //开启倒计时
             self.countdown2 = [dict[@"res"][@"data"][@"countdown"] intValue];
             self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread2) userInfo:nil repeats:YES];
             
             
             UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 190*base_H, 100*base_W, 20*base_H)];
             
             NSString *str1 = [NSString stringWithFormat:@"本轮复活需要:%@张开黑卡",dict[@"res"][@"data"][@"blackCard"]];
             
             NSString *str2 = [NSString stringWithFormat:@"(已有%@张)",dict[@"res"][@"data"][@"haveCard"]];
             
             NSString *str3 = [NSString stringWithFormat:@"  还需支付%@元",dict[@"res"][@"data"][@"owe"]];
             
             NSString *str4 = [NSString stringWithFormat:@"(已从账户余额抵%@元)",dict[@"res"][@"data"][@"mortgage"]];
             
             
             NSString *textStr =  [NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];
             
             NSMutableAttributedString *labelStr = [[NSMutableAttributedString alloc]initWithString:textStr];
             
             [labelStr setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0,str1.length)];
             
             [labelStr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#E5D5FF"],NSFontAttributeName:[UIFont systemFontOfSize:8]} range:NSMakeRange(str1.length, str2.length)];
             
             [labelStr setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(str1.length + str2.length, str3.length)];
             
             [labelStr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#E5D5FF"],NSFontAttributeName:[UIFont systemFontOfSize:8]} range:NSMakeRange(str1.length + str2.length + str3.length, str4.length)];
             
             lab1.attributedText = labelStr;
             lab1.textAlignment = NSTextAlignmentCenter;
             [cusView addSubview:lab1];
             [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(cusView);
                 make.height.mas_equalTo(20*base_H);
                 make.left.equalTo(cusView.mas_left);
                 make.bottom.equalTo(cusView.mas_bottom).offset(-87*base_H);
             }];
             
         
             
             double totalBonus = [dict[@"res"][@"data"][@"totalBonus"] doubleValue];
             NSString *totalStr = [NSString stringWithFormat:@"挺过本轮,我方有可能赢得总奖金：%.2f元",totalBonus];
             cusView.introLab.font = [UIFont systemFontOfSize:21];
             cusView.introLab.textColor = [UIColor colorWithHex:@"#FFE348"];
             NSMutableAttributedString *totalBonusStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
             [totalBonusStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 12)];//设置字体
             [totalBonusStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 12)];//设置颜色
             cusView.introLab.attributedText = totalBonusStr;
             
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
             UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150*base_W, 40*base_H)];
             [btn setTitle:@"拯救全队" forState:UIControlStateNormal];
             [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [btn addTarget:self action:@selector(saveFriend:) forControlEvents:UIControlEventTouchUpInside];
             [btn setBackgroundImage:[UIImage imageNamed:@"获胜-btn右-黄"]  forState:UIControlStateNormal];
             cusView.userInteractionEnabled = YES;
             [cusView addSubview:btn];
             [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(150*base_W);
                 make.height.mas_equalTo(40*base_H);
                 make.centerX.equalTo(cusView.mas_centerX);
                 make.top.equalTo(cusView.mainLab.mas_bottom).offset(5*base_H);
             }];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"rsFail"]){
             //复活失败
             NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a5.mp3";
             [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
             //复活失败
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#694CF2"];
             cusView.bgView.image = [UIImage imageNamed:@"复活成功背景"];
             cusView.mainView.image = [UIImage imageNamed:@"复活失败-插画"];
             cusView.tittleLab.text = @"复活失败 奖金送人";
             
             self.timeLab3 = cusView.timeLab;
             self.timeLab3.text = [NSString stringWithFormat:@"%@s",dict[@"res"][@"data"][@"countdown"]];
             //开启倒计时
             self.countdown3 = [dict[@"res"][@"data"][@"countdown"] intValue];
//             [self performSelectorInBackground:@selector(createThread3) withObject:nil];
             self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread3) userInfo:nil repeats:YES];
             cusView.mainLab.text = @"比赛结束，奖金送人";
             if ((int)dict[@"res"][@"data"][@"oppoRsSuccess"] == 1) {
                 cusView.introLab.text = @"抱歉，您与队友都没选择复活";
             }else{
                 cusView.introLab.text = @"抱歉，您与队友都没选择复活而对方选择了复活";
             }
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"rsSuccess"]){
             //复活成功
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //复活成功之后的音效
             NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a1.mp3";
             [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
             
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#FC596B"];
             cusView.bgView.image = [UIImage imageNamed:@"复活成功背景"];
             cusView.mainView.image = [UIImage imageNamed:@"复活成功-插画"];
             UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"res"][@"data"][@"avatar"]]]];
             cusView.samllView.image = image;
             cusView.tittleLab.text = @"复活成功";
             self.timeLab4 = cusView.timeLab;
             self.timeLab4.text = [NSString stringWithFormat:@"%@s",dict[@"res"][@"data"][@"countdown"]];
             //开启倒计时
             self.countdown4 = [dict[@"res"][@"data"][@"countdown"] intValue];
             self.timer4 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread4) userInfo:nil repeats:YES];
             if ([dict[@"res"][@"data"][@"isWin"] isEqualToString:@"win"]) {
                 cusView.mainLab.text = [NSString stringWithFormat:@"%@帮助我方全队复活，并赢得比赛",dict[@"res"][@"data"][@"nickname"]];
             }else{
                 cusView.mainLab.text = [NSString stringWithFormat:@"%@帮助我方全队复活，比赛继续",dict[@"res"][@"data"][@"nickname"]];
             }
             cusView.introLab.text = @"";
             
             NSString *realCardNum = [Single sharedInstance].realCardNum;
             
             int abc = [realCardNum intValue]-[self.fuhuoBlackCard intValue];
             if (abc >= 0) {
                 NSString *heiStr = [NSString stringWithFormat:@"%d",abc];
                 NSString *heikaStr = [@"开黑卡 " stringByAppendingString:heiStr];
                 self.blackLab.text = heikaStr;
             }else{
                 abc = 0;
                 NSString *heiStr = @"0";
                 NSString *heikaStr = [@"开黑卡 " stringByAppendingString:heiStr];
                 self.blackLab.text = heikaStr;
             }
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"gameResult"]){
             if ([dict[@"res"][@"data"][@"value"]isEqualToString:@"success"]) {
                 if (self.bigBGview) {
                     [self.bigBGview removeFromSuperview];
                 }
                 //比赛胜利
                 NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a6.mp3";
                 [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
                 //我方答错需要选择复活
                 self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
                 self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
                 CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
                 
                 //渐变色
                 UIView *bibiview = [[UIView alloc] initWithFrame:CGRectMake(0, 3*base_H,  Width-220*base_W, 30*base_H)];
                 CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
                 gradientLayer2.frame = bibiview.frame;
                 gradientLayer2.startPoint = CGPointMake(0, 0);
                 gradientLayer2.endPoint = CGPointMake(0, 1);
                 UIColor *startColor2 = [UIColor colorWithHex:@"#FFE348"];
                 UIColor *endColor2 = [UIColor colorWithHex:@"#F65E66"];
                 gradientLayer2.colors = @[(__bridge id)startColor2.CGColor,
                                           (__bridge id)endColor2.CGColor];
                 gradientLayer2.locations = @[@(0.1f), @(1.0f)];
                 gradientLayer2.cornerRadius = 10;
                 [bibiview.layer addSublayer:gradientLayer2];
                 [cusView addSubview:bibiview];
                 
                 //蓝色背景
                 cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#F65E66"];
                 
                 UIImageView *zanzhushangImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 350, 60)];
                 zanzhushangImgView.image = [UIImage imageNamed:@"获胜标题"];
                 [bibiview addSubview:zanzhushangImgView];
                 [zanzhushangImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(350*base_W);
                     make.height.mas_equalTo(60*base_H);
                     make.centerX.equalTo(bibiview.mas_centerX);
                     make.top.equalTo(bibiview.mas_top).offset(0);
                 }];
                 
                 UILabel *lunLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400*base_W, 20*base_H)];
                 lunLab.text = [NSString stringWithFormat:@"本场累计:对决%@轮",dict[@"res"][@"data"][@"round"]];
                 lunLab.font = [UIFont systemFontOfSize:14];
                 lunLab.textAlignment = NSTextAlignmentCenter;
                 lunLab.textColor = [UIColor whiteColor];
                 [cusView addSubview:lunLab];
                 [lunLab mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(400*base_W);
                     make.height.mas_equalTo(20*base_H);
                     make.centerX.equalTo(bibiview.mas_centerX);
                     make.top.equalTo(zanzhushangImgView.mas_bottom).offset(0);
                 }];
                 
                 UILabel *yuanLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400*base_W, 20*base_H)];
                 NSString *totalBonusStr = dict[@"res"][@"data"][@"bonus"];
                 double totalBonus = [totalBonusStr doubleValue];
                 yuanLab.text = [NSString stringWithFormat:@"我方团队独享全额奖金:%.2f元",totalBonus];
                 yuanLab.font = [UIFont systemFontOfSize:18];
                 yuanLab.textAlignment = NSTextAlignmentCenter;
                 yuanLab.textColor = [UIColor whiteColor];
                 [cusView addSubview:yuanLab];
                 [yuanLab mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(400*base_W);
                     make.height.mas_equalTo(20*base_H);
                     make.centerX.equalTo(bibiview.mas_centerX);
                     make.top.equalTo(lunLab.mas_bottom).offset(0);
                 }];
                 
                 
                 UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110*base_W, 90*base_H)];
                 leftImgView.image = [UIImage imageNamed:@"获胜-赚到"];
                 [cusView addSubview:leftImgView];
                 [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(110*base_W);
                     make.height.mas_equalTo(90*base_H);
                     make.top.equalTo(yuanLab.mas_bottom).offset(10*base_H);
                     make.left.equalTo(yuanLab.mas_left).offset(70*base_W);
                 }];
                 
                 UILabel *qianLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90*base_W, 20*base_H)];
                 qianLab.font = [UIFont systemFontOfSize:11];
                 qianLab.textAlignment = NSTextAlignmentCenter;
                 qianLab.textColor = [UIColor whiteColor];
                 qianLab.text = [NSString stringWithFormat:@"每人赚到:%@元",dict[@"res"][@"data"][@"oneBonus"]];;
                 [leftImgView addSubview:qianLab];
                 [qianLab mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(90*base_W);
                     make.height.mas_equalTo(20*base_H);
                     make.bottom.equalTo(leftImgView.mas_bottom).offset(-5*base_H);
                     make.centerX.equalTo(leftImgView.mas_centerX);
                 }];
                 
                 UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110*base_W, 90*base_H)];
                 rightImgView.image = [UIImage imageNamed:@"获胜得积分"];
                 [cusView addSubview:rightImgView];
                 [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(110*base_W);
                     make.height.mas_equalTo(90*base_H);
                     make.top.equalTo(leftImgView.mas_top);
                     make.left.equalTo(leftImgView.mas_right).offset(20*base_W);
                 }];
                 
                 UILabel *fenLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90*base_W, 20*base_H)];
                 fenLab.font = [UIFont systemFontOfSize:11];
                 fenLab.textAlignment = NSTextAlignmentCenter;
                 fenLab.textColor = [UIColor whiteColor];
                 fenLab.text = [NSString stringWithFormat:@"积分增加:%@分",dict[@"res"][@"data"][@"score"]];
                 [rightImgView addSubview:fenLab];
                 [fenLab mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(90*base_W);
                     make.height.mas_equalTo(20*base_H);
                     make.bottom.equalTo(rightImgView.mas_bottom).offset(-5*base_H);
                     make.centerX.equalTo(rightImgView.mas_centerX);
                 }];
                 
                 UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400*base_W, 20*base_H)];
                 levelLab.font = [UIFont systemFontOfSize:14];
                 levelLab.textAlignment = NSTextAlignmentCenter;
                 levelLab.textColor = [UIColor whiteColor];
                 levelLab.text = [NSString stringWithFormat:@"距离升级还差:%@分",dict[@"res"][@"data"][@"differ"]];
                 [cusView addSubview:levelLab];
                 [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(400*base_W);
                     make.height.mas_equalTo(20*base_H);
                     make.top.equalTo(rightImgView.mas_bottom).offset(5*base_H);
                     make.centerX.equalTo(cusView.mas_centerX);
                 }];
                 
                 UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150*base_W, 35*base_H)];
                 UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150*base_W, 35*base_H)];
                 [leftBtn setTitle:@"返回首页" forState:UIControlStateNormal];
                  [leftBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
                 [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [rightBtn setTitle:@"原队再战" forState:UIControlStateNormal];
                 
                [rightBtn addTarget:self action:@selector(repView) forControlEvents:UIControlEventTouchUpInside];
                 [rightBtn setBackgroundImage:[UIImage imageNamed:@"获胜-btn右-黄"]  forState:UIControlStateNormal];
                 [leftBtn setBackgroundImage:[UIImage imageNamed:@"获胜-btn左-白"] forState:UIControlStateNormal];
                 cusView.userInteractionEnabled = YES;
                 [cusView addSubview:leftBtn];
                 [cusView addSubview:rightBtn];
                 
                 [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(150*base_W);
                     make.height.mas_equalTo(35*base_H);
                     make.top.equalTo(levelLab.mas_bottom).offset(5*base_H);
                     make.left.equalTo(cusView.mas_left).offset(40.5*base_W);
                 }];
                 
                 [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(150*base_W);
                     make.height.mas_equalTo(35*base_H);
                     make.top.equalTo(leftBtn.mas_top);
                     make.right.equalTo(cusView.mas_right).offset(-40.5*base_W);
                 }];
                 
                 
                 [self.view addSubview:self.bigBGview];
                 [self.bigBGview addSubview:cusView];
             }else if ([dict[@"res"][@"data"][@"value"]isEqualToString:@"fail"]){
                 
                 if (self.bigBGview) {
                     [self.bigBGview removeFromSuperview];
                 }
                 //比赛失败
                 NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a14.mp3";
                 [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
                 //我方答错需要选择复活
                 self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
                 self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
                 CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
                 
                 //渐变色
                 UIView *bibiview = [[UIView alloc] initWithFrame:CGRectMake(0, 3*base_H,  Width-220*base_W, 30*base_H)];
                 CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
                 gradientLayer2.frame = bibiview.frame;
                 gradientLayer2.startPoint = CGPointMake(0, 0);
                 gradientLayer2.endPoint = CGPointMake(0, 1);
                 UIColor *startColor2 = [UIColor colorWithHex:@"#FFE348"];
                 UIColor *endColor2 = [UIColor colorWithHex:@"#612AB5"];
                 gradientLayer2.colors = @[(__bridge id)startColor2.CGColor,
                                           (__bridge id)endColor2.CGColor];
                 gradientLayer2.locations = @[@(0.1f), @(1.0f)];
                 gradientLayer2.cornerRadius = 10;
                 [bibiview.layer addSublayer:gradientLayer2];
                 [cusView addSubview:bibiview];
                 
                 //蓝色背景
                 cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#612AB5"];
                 
                 UIImageView *zanzhushangImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 350, 60)];
                 zanzhushangImgView.image = [UIImage imageNamed:@"败北标题"];
                 [bibiview addSubview:zanzhushangImgView];
                 [zanzhushangImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(350*base_W);
                     make.height.mas_equalTo(60*base_H);
                     make.centerX.equalTo(bibiview.mas_centerX);
                     make.top.equalTo(bibiview.mas_top).offset(0);
                 }];
                 
                 UILabel *lunLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 20)];
                 lunLab.text = [NSString stringWithFormat:@"本场累计:对决%@轮",dict[@"res"][@"data"][@"round"]];
                 lunLab.font = [UIFont systemFontOfSize:14];
                 lunLab.textAlignment = NSTextAlignmentCenter;
                 lunLab.textColor = [UIColor whiteColor];
                 [cusView addSubview:lunLab];
                 [lunLab mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(400*base_W);
                     make.height.mas_equalTo(20*base_H);
                     make.centerX.equalTo(bibiview.mas_centerX);
                     make.top.equalTo(zanzhushangImgView.mas_bottom).offset(0);
                 }];
                 
                 UILabel *yuanLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 20)];
                 
                 yuanLab.text = [NSString stringWithFormat:@"%@元奖金被对方独享!",dict[@"res"][@"data"][@"bonus"]];
                 yuanLab.font = [UIFont systemFontOfSize:18];
                 yuanLab.textAlignment = NSTextAlignmentCenter;
                 yuanLab.textColor = [UIColor whiteColor];
                 [cusView addSubview:yuanLab];
                 [yuanLab mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(400*base_W);
                     make.height.mas_equalTo(20*base_H);
                     make.centerX.equalTo(bibiview.mas_centerX);
                     make.top.equalTo(lunLab.mas_bottom).offset(0);
                 }];
                 
                 
                 UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 90)];
                 leftImgView.image = [UIImage imageNamed:@"败北插画"];
                 [cusView addSubview:leftImgView];
                 [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(80*base_W);
                     make.height.mas_equalTo(80*base_H);
                     make.centerX.equalTo(cusView.mas_centerX);
                     make.top.equalTo(yuanLab.mas_top).offset(20*base_H);
                 }];
                 
                 UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 20)];
                 levelLab.font = [UIFont systemFontOfSize:14];
                 levelLab.textAlignment = NSTextAlignmentCenter;
                 levelLab.textColor = [UIColor whiteColor];
                 levelLab.text = [NSString stringWithFormat:@"积分扣除%@分,距离降级还差:%@分",dict[@"res"][@"data"][@"score"],dict[@"res"][@"data"][@"score"]];
                 [cusView addSubview:levelLab];
                 [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(400*base_W);
                     make.height.mas_equalTo(20*base_H);
                     make.top.equalTo(leftImgView.mas_bottom).offset(10*base_H);
                     make.centerX.equalTo(cusView.mas_centerX);
                 }];
                 
                 UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
                 UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
                 [leftBtn setTitle:@"返回首页" forState:UIControlStateNormal];
                 [leftBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
                 [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 cusView.userInteractionEnabled = YES;
                 [rightBtn setTitle:@"原队再战" forState:UIControlStateNormal];
                  [rightBtn addTarget:self action:@selector(repView) forControlEvents:UIControlEventTouchUpInside];
                 [rightBtn setBackgroundImage:[UIImage imageNamed:@"获胜-btn右-黄"]  forState:UIControlStateNormal];
                 [leftBtn setBackgroundImage:[UIImage imageNamed:@"获胜-btn左-白"] forState:UIControlStateNormal];
                 [cusView addSubview:leftBtn];
                 [cusView addSubview:rightBtn];
                 
                 [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(150*base_W);
                     make.height.mas_equalTo(35*base_H);
                     make.top.equalTo(levelLab.mas_bottom).offset(20*base_H);
                     make.left.equalTo(cusView.mas_left).offset(65*base_W);
                 }];
                 
                 [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(150*base_W);
                     make.height.mas_equalTo(35*base_H);
                     make.top.equalTo(leftBtn.mas_top);
                     make.right.equalTo(cusView.mas_right).offset(-65*base_W);
                 }];
                 
                 
                 [self.view addSubview:self.bigBGview];
                 [self.bigBGview addSubview:cusView];
             }else if ([dict[@"res"][@"data"][@"value"]isEqualToString:@"equal"]){
             }
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"waitSave"]){
             //我方答对等待对方是否选择复活
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];;
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#694CF2"];
             cusView.bgView.image = [UIImage imageNamed:@""];
             cusView.mainView.image = [UIImage imageNamed:@"等待对手复活"];
             cusView.samllView.image = [UIImage imageNamed:@""];
             cusView.tittleLab.text = @"等待对手复活";

             cusView.introLab.text = @"对方正在选择是否复活";
             cusView.mainLab.text = [NSString stringWithFormat:@"%@s请耐心等待",dict[@"res"][@"data"][@"countdown"]];
             self.timeLab5 = cusView.mainLab;
             self.countdown5 = [dict[@"res"][@"data"][@"countdown"] intValue];
             //             [self performSelectorInBackground:@selector(createThread5) withObject:nil];
             self.timer5 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread5) userInfo:nil repeats:YES];
             
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"lastQuestion"]){
             //最后一题
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#6C49F2"];
             //        cusView.bgView.image = [UIImage imageNamed:@"复活成功背景"];
             cusView.mainView.image = [UIImage imageNamed:@"闹钟1"];
             cusView.samllView.image = [UIImage imageNamed:@""];
             cusView.tittleLab.text = @"最后决战 一题决胜";
             self.timeLab6 = cusView.timeLab;
             self.timeLab6.text = [NSString stringWithFormat:@"%@s",dict[@"res"][@"data"][@"countdown"]];
             //开启倒计时
             self.countdown6 = [dict[@"res"][@"data"][@"countdown"] intValue];
             self.timer6 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread6) userInfo:nil repeats:YES];
             cusView.mainLab.text = @"本题答错后不能使用开黑卡复活";
             cusView.introLab.text = @"双方打平，先选的一方获胜";
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"waitPay"]){
             //我方等待支付
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //对手复活成功之后的音效
             NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a3.mp3";
             [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#694CF2"];
             cusView.bgView.image = [UIImage imageNamed:@"复活成功背景"];
             cusView.mainView.image = [UIImage imageNamed:@"复活成功-插画"];
             cusView.samllView.image = [UIImage imageNamed:@""];
             cusView.tittleLab.text = @"等待队友拯救";
             cusView.mainLab.text = @"我方队友正在购买开黑卡...";
             cusView.introLab.text = [NSString stringWithFormat:@"%@s耐心等待他的拯救",dict[@"res"][@"data"][@"countdown"]];
             self.timeLab7 = cusView.introLab;
             //开启倒计时
             self.countdown7 = [dict[@"res"][@"data"][@"countdown"] intValue];
              self.timer7 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread7) userInfo:nil repeats:YES];
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"waitOppositePay"]){
             //我方等待对方支付
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //对手复活成功之后的音效
             NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a3.mp3";
             [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#694CF2"];
             cusView.bgView.image = [UIImage imageNamed:@""];
             cusView.mainView.image = [UIImage imageNamed:@"等待对手复活"];
             cusView.samllView.image = [UIImage imageNamed:@""];
             cusView.tittleLab.text = @"等待对手复活";
             
             cusView.introLab.text = @"对方正在购买开黑卡";
             cusView.mainLab.text = [NSString stringWithFormat:@"%@s请耐心等待",dict[@"res"][@"data"][@"countdown"]];
             self.timeLab8 = cusView.mainLab;
             //开启倒计时
             self.countdown8 = [dict[@"res"][@"data"][@"countdown"] intValue];
            self.timer8 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread8) userInfo:nil repeats:YES];
             
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"oppoRsSuccess"]){
             
             //对手复活成功之后的音效
             NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a4.mp3";
             [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
             
             //对方复活成功
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_H)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#694CF2"];
             cusView.bgView.image = [UIImage imageNamed:@"复活成功背景"];
             UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"res"][@"data"][@"avatar"]]]];
             cusView.mainView.image = [UIImage imageNamed:@"复活成功-插画"];
             cusView.samllView.image = image;
             cusView.tittleLab.text = @"对方复活成功";
             self.timeLab9 = cusView.timeLab;
             self.timeLab9.text = [NSString stringWithFormat:@"%@s",dict[@"res"][@"data"][@"countdown"]];
             //开启倒计时
             self.countdown9 = [dict[@"res"][@"data"][@"countdown"] intValue];
              self.timer9 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread9) userInfo:nil repeats:YES];
             cusView.introLab.text = @"对方复活成功，继续战斗吧!";
             cusView.mainLab.text = @"鏖战越久,奖金池会越大哦!";
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
         }else if ([dict[@"res"][@"messageType"] isEqualToString:@"allDead"]){
             
             //都未复活
             NSString *url = @"http://file.zzkaihei.com/zzkh/vodio/a5.mp3";
             [self.audioPlayer startPlayWithUrl:url isLocalFile:NO];
             
             //对方复活成功
             if (self.bigBGview) {
                 [self.bigBGview removeFromSuperview];
             }
             //我方答错需要选择复活
             self.bigBGview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
             self.bigBGview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
             CustomAlertView *cusView = [[CustomAlertView alloc] initWithFrame:CGRectMake(110*base_W, 50*base_H, Width-220*base_W, Height-70*base_W)];
             //蓝色背景
             cusView.bgView.backgroundColor = [UIColor colorWithHex:@"#694CF2"];
             cusView.bgView.image = [UIImage imageNamed:@"复活选择背景2"];
             cusView.mainView.image = [UIImage imageNamed:@"复活失败-插画"];
             cusView.samllView.image = [UIImage imageNamed:@""];
             cusView.tittleLab.text = @"复活失败";
             self.timeLab10 = cusView.timeLab;
             self.timeLab10.text = [NSString stringWithFormat:@"%@s",dict[@"res"][@"data"][@"countdown"]];
             //开启倒计时
             self.countdown10 = [dict[@"res"][@"data"][@"countdown"] intValue];
              self.timer10 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createThread10) userInfo:nil repeats:YES];
             cusView.introLab.text = @"双方都未复活";
             cusView.mainLab.text = @"双方都未复活,比赛继续";
             [self.view addSubview:self.bigBGview];
             [self.bigBGview addSubview:cusView];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"--%@--",error);
     }];
 }

- (void)saveFriend:(UIButton *)sender{
    [sender setBackgroundImage:[UIImage imageNamed:@"获胜-btn左-白"]  forState:UIControlStateNormal];
//    [sender setTitle:@"正在复活" forState:UIControlStateNormal];
    sender .userInteractionEnabled = NO;
    //拯救
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dataDictionary = @{
                                     @"TokenZZKH":[Single sharedInstance].token,
                                     @"ruleId":self.ruleId,
                                     @"roomNum":self.roomId,
                                     @"messageType":@"save"
                                     };
    
    [manager POST:[NSString stringWithFormat:@"%@/websocket/send",APPHostT] parameters:dataDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--%@--",dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}

- (void)createThread1{
    //撒钱
    self.countdown1 --;
    if (self.countdown1 <= 0) {
        self.timeLab1.text=[NSString stringWithFormat:@"0s"];
        [self.timer1 invalidate];
    }else{
        self.timeLab1.text=[NSString stringWithFormat:@"%ds",self.countdown1];
    }
}
- (void)createThread2{
    //撒钱
    self.countdown2 --;
    if (self.countdown2 <= 0) {
        self.timeLab2.text=[NSString stringWithFormat:@"0s"];
        [self.timer2 invalidate];
    }else{
        self.timeLab2.text=[NSString stringWithFormat:@"%ds",self.countdown2];
    }
}
- (void)createThread3{
    //撒钱
    self.countdown3 --;
    if (self.countdown3 <= 0) {
        self.timeLab3.text=[NSString stringWithFormat:@"0s"];
         [self.timer3 invalidate];
    }else{
        self.timeLab3.text=[NSString stringWithFormat:@"%ds",self.countdown3];
        
    }
}
- (void)createThread4{
    //撒钱
    self.countdown4 --;
    if (self.countdown4 <= 0) {
        self.timeLab4.text=[NSString stringWithFormat:@"0s"];
         [self.timer4 invalidate];
    }else{
        self.timeLab4.text=[NSString stringWithFormat:@"%ds",self.countdown4];
    }
}
- (void)createThread5{
    //撒钱
    self.countdown5 --;
    if (self.countdown5 <= 0) {
        self.timeLab5.text=[NSString stringWithFormat:@"0s请耐心等待"];
         [self.timer5 invalidate];
    }else{
        self.timeLab5.text=[NSString stringWithFormat:@"%ds请耐心等待",self.countdown5];
    }
}
- (void)createThread6{
    //撒钱
    self.countdown6 --;
    if (self.countdown6 <= 0) {
        self.timeLab6.text=[NSString stringWithFormat:@"0s"];
         [self.timer6 invalidate];
    }else{
       self.timeLab6.text=[NSString stringWithFormat:@"%ds",self.countdown6];
    }
}
- (void)createThread7{
    //撒钱
    self.countdown7 --;
    if (self.countdown7 <= 0) {
        self.timeLab7.text=[NSString stringWithFormat:@"0s耐心等待他的拯救"];
         [self.timer7 invalidate];
    }else{
        
        self.timeLab7.text=[NSString stringWithFormat:@"%ds耐心等待他的拯救",self.countdown7];
    }
}
- (void)createThread8{
    //撒钱
    self.countdown8 --;
    if (self.countdown8 <= 0) {
        self.timeLab8.text=[NSString stringWithFormat:@"0s请耐心等待"];
         [self.timer8 invalidate];
    }else{
        self.timeLab8.text=[NSString stringWithFormat:@"%ds请耐心等待",self.countdown8];
    }
}
- (void)createThread9{
    //撒钱
    self.countdown9 --;
    if (self.countdown9 <= 0) {
         self.timeLab9.text=[NSString stringWithFormat:@"0s"];
         [self.timer9 invalidate];
    }else{
       self.timeLab9.text=[NSString stringWithFormat:@"%ds",self.countdown9];
    }
}
- (void)createThread10{
    //撒钱
    self.countdown10 --;
    if (self.countdown10 <= 0) {
        self.timeLab10.text=[NSString stringWithFormat:@"0s"];
        [self.timer10 invalidate];
        
    }else{
        self.timeLab10.text=[NSString stringWithFormat:@"%ds",self.countdown10];
    }
}


- (void)closeView{    
    UIViewController * presentingViewController = self.presentingViewController;
    while (presentingViewController.presentingViewController) {
        presentingViewController = presentingViewController.presentingViewController;
    }
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)repView{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[Single sharedInstance].token forHTTPHeaderField:@"TokenZZKH"];
    NSDictionary *dataDictionary = @{
                                     @"matchNum":self.roomId,
                                     };
    [manager POST:@"https://zzkh.kai-hei.com/zzkhapi/matchuser/againCreateMatchUser" parameters:dataDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--%@--",dict);
        if ([dict[@"message"] isEqualToString:@"success"]) {
            if (![dict[@"res"] objectForKey:@"matchNum"]) {
                UIViewController * presentingViewController = self.presentingViewController;
                while (presentingViewController.presentingViewController) {
                    presentingViewController = presentingViewController.presentingViewController;
                }
                [presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }else{
                NSDictionary *dic = @{
                                      @"roomNum":dict[@"res"][@"matchNum"],
                                      @"ruleId":self.ruleId,
                                      @"token":[Single sharedInstance].token
                                      };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeLabelTextNotification" object:dic];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}


- (void)viewDidDisappear:(BOOL)animated{
    [self.lunxunTimer invalidate];
    [self.audioPlayer stopPlaying];
}

//支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}
@end

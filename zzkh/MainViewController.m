//
//  ViewController.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/8.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "MainViewController.h"
#import "WXApi.h"
#import "Header.h"
#import "WXApiObject.h"
#import "AFNetworking.h"
#import "AnswerViewController.h"
#import "scoketViewController.h"
#import "ExercisesViewController.h"
#import "LoadingViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface MainViewController ()<WXApiDelegate,UIWebViewDelegate>
@property (nonatomic, strong)UIButton *btn;
@property (nonatomic, strong)UIButton *shareBtn;
@property (nonatomic, strong)UIButton *payBtn;
@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, strong)UIButton *answerBtn;

@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, copy)NSString *urlStr;

@property (nonatomic, copy) NSMutableDictionary *param;//前段返回数据
@property (nonatomic, copy) NSString *roomNum;

@property (nonatomic, copy) NSString *payResult;

@property (nonatomic, copy) NSString *weixinCode;
//支付信息
@property (nonatomic, strong) NSDictionary *orderDict;
//个人信息
@property (nonatomic, strong) NSDictionary *userDict;
//模仿启动页
@property (nonatomic, strong) UIView *launchView;
@end
#define appid wx3a57615d9c90cd1f
@implementation MainViewController{
    JSContext *jsContext;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlStr = [request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"解码：%@",urlStr);

    if ([urlStr hasPrefix:@"js://login"]) {
        //登录
        [self clickBtn];
    }else if ([urlStr hasPrefix:@"js://pay"]){
        //支付
        NSDictionary *params = [self jsonToString:urlStr];
        self.orderDict = params[@"orderInfo"];
        [self clickPayBtn];
        
        return NO;
    }else if ([urlStr hasPrefix:@"js://searchAdd"]){
         NSDictionary *params = [self jsonToString:urlStr];
        //加入对局
        AnswerViewController *answerVC = [[AnswerViewController alloc] init];
        answerVC.roomId = params[@"matchNum"];
        NSString*jsonStr = params[@"ruleInfo"];
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@", [obj class]);
        answerVC.ruleId = obj[@"id"];
        answerVC.leftNum = [obj[@"pkNumOne"] intValue];
        answerVC.rightNum = [obj[@"pkNumTwo"] intValue];
        answerVC.startMoney = obj[@"initMoney"];//起始金额
        answerVC.zanzhuName = obj[@"sponsor"];//赞助商姓名
        answerVC.topMoney = obj[@"topMoney"];//每场最高金额
        answerVC.needNum = obj[@"need"];//需要开黑卡
        answerVC.bettalPic = obj[@"vsImg"];//对局图片
        [self presentViewController:answerVC animated:YES completion:nil];
        
    }else if ([urlStr hasPrefix:@"js://userInfo"]){
        NSDictionary *params = [self jsonToString:urlStr];
        self.userDict = params[@"userInfo"];
        NSString*jsonStr = params[@"userInfo"];
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@", [obj class]);
        [Single sharedInstance].token = params[@"token"];
        [Single sharedInstance].rankNum = obj[@"users"][@"rankNum"];
        [Single sharedInstance].province = obj[@"users"][@"province"];
        [Single sharedInstance].levelImg = obj[@"users"][@"levelImg"];
        [Single sharedInstance].phone = obj[@"users"][@"phone"];
        [Single sharedInstance].unionId = obj[@"users"][@"unionId"];
        [Single sharedInstance].nickName = obj[@"users"][@"nickName"];
        [Single sharedInstance].nickImage = obj[@"users"][@"nickImage"];
        [Single sharedInstance].levelName = obj[@"users"][@"levelName"];
        [Single sharedInstance].needScore = obj[@"users"][@"next"][@"needScore"];
        [Single sharedInstance].userMoney =  obj[@"users"][@"userMoney"];
        [Single sharedInstance].realCardNum =  obj[@"users"][@"reliveCardNum"];
        
    }else if ([request.URL.absoluteString hasPrefix:@"js://share"]){
        //分享
        [self clickShareBtn];
    }else if ([urlStr hasPrefix:@"js://addMatch"]){
        NSDictionary *params = [self jsonToString:urlStr];
        //开始对局余额
        AnswerViewController *answerVC = [[AnswerViewController alloc] init];
        answerVC.roomId = params[@"matchNum"];
        self.roomNum = params[@"matchNum"];
        NSString*jsonStr = params[@"ruleInfo"];
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@", [obj class]);
        answerVC.ruleId = obj[@"id"];
        answerVC.leftNum = [obj[@"pkNumOne"] intValue];
        answerVC.rightNum = [obj[@"pkNumTwo"] intValue];
        answerVC.startMoney = obj[@"initMoney"];//起始金额
        answerVC.zanzhuName = obj[@"sponsor"];//赞助商姓名
        answerVC.topMoney = obj[@"topMoney"];//每场最高金额
        answerVC.needNum = obj[@"need"];//需要开黑卡
        answerVC.bettalPic = obj[@"vsImg"];//对局图片
        [self presentViewController:answerVC animated:YES completion:nil];
    }
    return YES;
}

- (void)clickBBB:(UIButton *)btn{
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
}

- (void)delayMethod{
     NSURL *telURL =[NSURL URLWithString:self.urlStr];
     NSLog(@"self.urlStr===%@",self.urlStr);
     [self.webView loadRequest:[NSURLRequest requestWithURL:telURL]];
}

- (void)viewWillAppear:(BOOL)animated{
}

/**获取当前window*/
- (UIWindow *)getCurrentWindowView {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.launchView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView * backImageView = [[UIImageView alloc] initWithFrame:self.launchView.bounds];
    backImageView.image = [UIImage imageNamed:@"launch"];
    [self.launchView addSubview:backImageView];
//    [[self getCurrentWindowView] addSubview:self.launchView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.urlStr = @"https://zzkh.kai-hei.com/";
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    NSURL *telURL =[NSURL URLWithString:self.urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:telURL]];
    //controller中添加
     self.navigationController.navigationBar.hidden = YES;
    
    
 
    [self.view addSubview:self.webView];
    
    //分享
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickShareBtn) name:@"inventFriend" object:nil];
    //重新刷新web
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBBB:) name:@"updateUI" object:nil];
    
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    //定义好JS要调用的方法, share就是调用的share方法名
//    context[@"share"] = ^() {
//        NSLog(@"+++++++Begin Log+++++++");
//        NSArray *args = [JSContext currentArguments];
//
//
//
//        for (JSValue *jsVal in args) {
//            NSLog(@"JS+++++====%@", jsVal.toString);
//        }
//
//        NSLog(@"-------End Log-------");
//    };
//}

- (void)clickBtn{
    //微信登陆
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *request = [[SendAuthReq alloc] init];
        request.state = @"";//非必需，用于防止csrf攻击
        request.scope = @"snsapi_userinfo";//授权域
        //request.openID ==
        [WXApi sendReq:request];
    }
}

- (void)onResp:(BaseResp *)resp{

    NSLog(@"resp:%d",resp.errCode);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *rep = (SendAuthResp *)resp;
        if (rep.errCode == 0) {
            //登录成功
            NSLog(@"error.code===%d",rep.errCode);
            self.weixinCode = rep.code;
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *name =rep.code;
            [defaults setObject: name forKey:@"name"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil];
        }
    } else if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        if (response.errCode ==  WXSuccess) {
            NSLog(@"支付成功，retcode=%d",resp.errCode);
            self.payResult = @"true";
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil];
        }else{
            NSLog(@"支付失败，retcode=%d",resp.errCode);
            self.payResult = @"false";
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil];
        }
    }
}

#pragma --微信分享
- (void)clickShareBtn{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[Single sharedInstance].token forHTTPHeaderField:@"TokenZZKH"];
    NSDictionary *dict = @{
                           @"matchNum":self.roomNum,
                           };
    NSString *url = [NSString stringWithFormat:@"%@match/inviteFrineds",APPHostTT];
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--%@--",dict);
        if ([dict[@"message"] isEqualToString:@"success"]) {
            
            WXMiniProgramObject *wxMiniObject = [WXMiniProgramObject object];
            wxMiniObject.webpageUrl = dict[@"res"][@"shareVo"][@"webpageUrl"];
            wxMiniObject.userName = @"gh_537f1aafd6b9";
            wxMiniObject.path = dict[@"res"][@"shareVo"][@"webpageUrl"];
             NSURL *picUrl = [NSURL URLWithString:dict[@"res"][@"shareVo"][@"thumb"]];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:picUrl]];
            NSData *data = UIImageJPEGRepresentation(image, 0.4);
            wxMiniObject.hdImageData = data;
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = dict[@"res"][@"shareVo"][@"title"];
            message.description = dict[@"res"][@"shareVo"][@"description"];
            message.mediaObject = wxMiniObject;
            message.thumbData = nil;
            SendMessageToWXReq *rep = [[SendMessageToWXReq alloc] init];
            rep.message = message;
            rep.scene = WXSceneSession;
            [WXApi sendReq:rep];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}

#pragma --微信支付
- (void)clickPayBtn{
    PayReq *request = [[PayReq alloc] init];
    NSLog(@"self.orderDict===%@",self.orderDict);
    request.partnerId = self.orderDict[@"partnerid"];;
    request.prepayId= self.orderDict[@"prepayid"];
    request.package = self.orderDict[@"package"];
    request.nonceStr= self.orderDict[@"nonceStr"];
    NSString *str = self.orderDict[@"timestamp"];
    request.timeStamp= [str intValue];
    request.sign= _orderDict[@"sign"];
    [WXApi sendReq:request];
}
#pragma mark -- 设置横屏
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

//当网页视图已经开始加载一个请求后，得到通知。
-(void)webViewDidStartLoad:(UIWebView*)webView {
  
}

//当网页视图结束加载一个请求之后，得到通知。
-(void)webViewDidFinishLoad:(UIWebView*)webView {
    
    
    //js调用原声方法
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, share就是调用的share方法名
    
    
    context[@"ios_pay"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        for (JSValue *jsVal in args) {
            NSLog(@"JS+++++====%@", jsVal.toString);
            NSString *str = jsVal.toString;
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *error;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"dic===%@",dic);
            
            
            PayReq *request = [[PayReq alloc] init];
            
            request.partnerId = dic[@"partnerid"];;
            request.prepayId= dic[@"prepayid"];
            request.package = dic[@"package"];
            request.nonceStr= dic[@"noncestr"];
            NSString *WXStr = dic[@"timestamp"];
            request.timeStamp= [WXStr intValue];
            request.sign= dic[@"sign"];
            
            NSLog(@"1===%@,2===%@,3===%@,4===%@,5===%u,6===%@",request.partnerId,request.prepayId,request.package,request.nonceStr,(unsigned int)request.timeStamp,request.sign);
            [WXApi sendReq:request];
        }
        
        NSLog(@"-------End Log-------");
    };
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.launchView removeFromSuperview];
    }];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name"];//根据键值取出name
    if (name == nil) {
        
    }else{
        NSString *codeStr = [NSString stringWithFormat:@"weixinlogin('%@')",name];
        [self.webView stringByEvaluatingJavaScriptFromString:codeStr];
        static dispatch_once_t disOnce; 
        dispatch_once(&disOnce,^ {
//              [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
        });
    }
    if ([self.payResult isEqualToString:@"false"]) {
        NSString *codeStr = [NSString stringWithFormat:@"paySuccess('true')"];
        [self.webView stringByEvaluatingJavaScriptFromString:codeStr];
    }else if ([self.payResult isEqualToString:@"true"]){
        NSString *codeStr = [NSString stringWithFormat:@"paySuccess('false')"];
        [self.webView stringByEvaluatingJavaScriptFromString:codeStr];
    }else{
        NSLog(@"-=-=");
    }
}

//当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型。
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSDictionary *)jsonToString:(NSString *)urlStr{
    NSRange range = [urlStr rangeOfString:@"?"];
    if(range.location==NSNotFound) {
        return  nil;
    }
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    NSString  *parametersString = [urlStr substringFromIndex:range.location+1];
    if ([parametersString containsString:@"&"]) {
        NSArray  *urlComponents = [parametersString   componentsSeparatedByString:@"&"];
        for(NSString *keyValuePair in urlComponents) {
            //生成key/value
            NSArray *pairComponents = [keyValuePair  componentsSeparatedByString:@"="];
            
            NSString *key = [pairComponents.firstObject  stringByRemovingPercentEncoding];
            
            NSString*value = [pairComponents.lastObject  stringByRemovingPercentEncoding];
            if(key==nil|| value ==nil) {
                continue;
            }
            [params setValue:value forKey:key];
        }
    }
    NSLog(@"-=-%@-=-=",params);
    return params;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

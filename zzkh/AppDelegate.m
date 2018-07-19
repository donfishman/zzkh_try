//
//  AppDelegate.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/8.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "MainViewController.h"
#import "CusNavViewController.h"
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件
#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库
#import "MustUploadView.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //向微信注册
    [WXApi registerApp:@"wx3a57615d9c90cd1f" enableMTA:YES];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [application setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    [self.window makeKeyAndVisible];
    MainViewController *vc  =[[MainViewController alloc]init];
    CusNavViewController *nav = [[CusNavViewController alloc]initWithRootViewController:vc];
    [self.window setRootViewController:nav];
    
    [self GetVersion];
    
    //友盟
    [UMConfigure initWithAppkey:@"Your appkey" channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    MainViewController *vc = [[MainViewController alloc] init];
    [WXApi handleOpenURL:url delegate:vc];
    return YES;
//    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

#pragma -- 版本更新
- (void)GetVersion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[Single sharedInstance].token forHTTPHeaderField:@"TokenZZKH"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [@"v" stringByAppendingString:app_Version];
    NSDictionary *dict = @{
                           @"version":versionStr,
                           @"system":@"2"
                           };
    NSString *url = [NSString stringWithFormat:@"%@eversion/getVersion",APPHostTT];
    NSLog(@"url===%@",url);
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"--%@--",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"--%@--",dict);
        if ([dict[@"message"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [dict[@"res"][@"ver"] firstObject];
            NSString *decodeString = [dataDic[@"appUrl"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([dataDic[@"updating"] isEqualToString:@"0"]) {
                //系统正常运行
                if ([dataDic[@"haveTo"]isEqualToString:@"0"]) {
                    //非必需更新
                    NSLog(@"haveTo===%@",dataDic[@"haveTo"]);
                    MustUploadView *view = [[MustUploadView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
                    [view drawRectWithStr:@""];
                    view.cancleBtn.hidden = YES;
                    [[UIApplication sharedApplication].keyWindow addSubview:view];
                } else if([dataDic[@"haveTo"]isEqualToString:@"1"]){
                    //强制更新
                    MustUploadView *view = [[MustUploadView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
                    [view drawRectWithStr:@""];
                    [[UIApplication sharedApplication].keyWindow addSubview:view];
                }
            }else{
                //系统维护
                MustUploadView *view = [[MustUploadView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
                [view drawRectAboutSave];
                [[UIApplication sharedApplication].keyWindow addSubview:view];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@--",error);
    }];
}

//从外部调回app会调用此方法
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    MainViewController *vc = [[MainViewController alloc] init];
    [WXApi handleOpenURL:url delegate:vc];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

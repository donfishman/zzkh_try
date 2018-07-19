//
//  LoadingViewController.h
//  zzkh
//
//  Created by 旭鹏 on 2018/6/14.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CallBackBlock) (NSString *text);
@interface LoadingViewController : UIViewController
@property (nonatomic, copy) CallBackBlock callBackBlock;

@property (nonatomic, copy) NSString *allTime;
@property (nonatomic, copy) NSString *remainTime;

@property (nonatomic, copy) NSString *ruleId;
@property (nonatomic, copy) NSString *roomId;

@property (assign) int leftNum;
@property (assign) int rightNum;
@property (nonatomic, copy) NSString *userName;//用户姓名
@end

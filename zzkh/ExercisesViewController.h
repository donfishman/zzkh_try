//
//  ExercisesViewController.h
//  zzkh
//
//  Created by 旭鹏 on 2018/6/13.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExercisesViewController : UIViewController
@property (nonatomic, copy) NSString *ruleId;
@property (nonatomic, copy) NSString *roomId;

@property (assign) int leftNum;
@property (assign) int rightNum;
@property (nonatomic , copy) NSString *unionId;//用户id

//服务器返回数据
@property (nonatomic , copy) NSString *tittleStr;//题干
@property (nonatomic , copy) NSMutableArray *optionArr;//选项
@property (nonatomic , copy) NSString *blackaCrd;//复活所需黑卡
@property (nonatomic , copy) NSString *currentNum;//当前关卡数
@property (nonatomic , copy) NSString *totelNum;//总题数
@property (assign) int countdown;//倒计时
@property (nonatomic , copy) NSString *awardPool;//奖金池金额


@end

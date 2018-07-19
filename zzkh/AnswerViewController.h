//
//  AnswerViewController.h
//  zzkh
//
//  Created by 旭鹏 on 2018/6/11.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerViewController : UIViewController
@property (nonatomic, copy) NSString *ruleId;
@property (nonatomic, copy) NSString *roomId;
//左右两边人数
@property (assign) int leftNum;
@property (assign) int rightNum;
@property (nonatomic, copy) NSString *startMoney;//起始金额
@property (nonatomic, copy) NSString *userName;//用户姓名
@property (nonatomic, copy) NSString *zanzhuName;//赞助商姓名
@property (nonatomic, copy) NSString *topMoney;//每场最高金额
@property (nonatomic, copy) NSString *needNum;//需要开黑卡
@property (nonatomic, copy) NSString *bettalPic;//对局图片

@property (nonatomic, copy) NSString *seachRoom;
@end

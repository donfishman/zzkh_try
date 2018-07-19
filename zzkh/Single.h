//
//  Single.h
//  Test
//
//  Created by 旭鹏 on 2018/5/25.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Single : NSObject
+(instancetype)sharedInstance;

@property (nonatomic, copy) NSString *str;//左右
@property (nonatomic, copy) NSString *token;
//个人信息
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *unionId;
@property (nonatomic, copy) NSString *nickImage;//左右
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *phone;//左右
@property (nonatomic, copy) NSString *userMoney;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *levelId;
@property (nonatomic, copy) NSString *levelScore;
@property (nonatomic, copy) NSString *levelName;//左右
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *realCardNum;
@property (nonatomic, copy) NSString *reliveCardNum;
@property (nonatomic, copy) NSString *levelImg;
@property (nonatomic, copy) NSString *rankNum;
@property (nonatomic, copy) NSString *needScore;

@end

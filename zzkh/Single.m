//
//  Single.m
//  Test
//
//  Created by 旭鹏 on 2018/5/25.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "Single.h"

@implementation Single

//通过类方法创建类对象
+(instancetype)sharedInstance{

    //用到静态变量的知识，静态变量只初始化一次
    static Single *single = nil;
    if (single == nil) {
        single = [[Single alloc] init];
    }
    return single;
}

@end

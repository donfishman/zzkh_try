//
//  HeadView.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/14.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "HeadView.h"
#import "Header.h"
#import "UserImageView.h"

@implementation HeadView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
//    if (self) {
//        //初始化代码
//        [self drawRectView];
//    }
    return self;
}
- (void)drawRectView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"个人信息背景.png"];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17*base_W);
        make.width.mas_equalTo(405*base_W);
        make.top.mas_equalTo (4*base_H);
        make.height.mas_equalTo (47.5*base_H);
    }];
    
    UIImageView *nameImg = [[UIImageView alloc] init];
    [nameImg setImage: [UIImage imageNamed:@"姓名色块.png"]];
    [imageView addSubview:nameImg];
    [nameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).offset(10.5*base_W);
        make.top.equalTo(imageView.mas_top).offset(4.5*base_H);
        make.width.mas_equalTo(135.5*base_W);
        make.height.mas_equalTo(17.5*base_H);
    }];
    
    UILabel *nameLab = [[UILabel alloc] init];
    NSString *nameStr =  [NSString stringWithFormat:@"%@ ",[Single sharedInstance].nickName];
    NSString *levelStr =  [NSString stringWithFormat:@"%@",[Single sharedInstance].levelName];
    nameLab.text = [nameStr stringByAppendingString:levelStr];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:11*base_H];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:nameLab];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameImg.mas_left).offset(20*base_W);
        make.top.equalTo(nameImg.mas_top).offset(2*base_H);
        make.width.mas_equalTo(95*base_W);
        make.height.mas_equalTo(14*base_H);
    }];
    
    
    UIImageView *levelImg = [[UIImageView alloc] init];
    [levelImg setImage: [UIImage imageNamed:@"距离色块.png"]];
    [imageView addSubview:levelImg];
    
    [levelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).offset(15.5*base_W);
        make.top.equalTo(nameImg.mas_bottom).offset(4.5*base_H);
        make.width.mas_equalTo(107.5*base_W);
        make.height.mas_equalTo(11.5*base_H);
    }];
    
    UILabel *levelLab = [[UILabel alloc] init];
    levelLab.text = [NSString stringWithFormat:@"距下一等级还差%@分",[Single sharedInstance].needScore];
    levelLab.textColor = [UIColor blackColor];
    levelLab.font = [UIFont systemFontOfSize:8*base_H];
    levelLab.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:levelLab];
    
    [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(levelImg.mas_left).offset(20*base_W);
        make.top.mas_equalTo(levelImg.mas_top);
        make.height.mas_equalTo(levelImg);
        make.width.mas_equalTo(74*base_W);
    }];
    
    UserImageView *iconImg = [[UserImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    iconImg.smallImgView.backgroundColor = [UIColor orangeColor];
    iconImg.smallImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Single sharedInstance].nickImage]]];
    [imageView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).offset(-25);
        make.top.equalTo(imageView.mas_top).offset(-8);
    }];
    
    UILabel *yueLab = [[UILabel alloc] init];
    yueLab.backgroundColor = [UIColor colorWithHex:@"#4800C6"];
    NSString *yuStr = [NSString stringWithFormat:@"%@元",[Single sharedInstance].userMoney];
    NSString *yueStr = [@"钱包 " stringByAppendingString:yuStr];
    yueLab.text = yueStr;
    yueLab.font = [UIFont systemFontOfSize:11];
    yueLab.textAlignment = NSTextAlignmentCenter;
    yueLab.textColor = [UIColor whiteColor];
    [imageView addSubview:yueLab];
    
    [yueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameImg.mas_right).offset(49*base_W);
        make.width.mas_equalTo(73*base_W);
        make.height.mas_equalTo(15.5*base_H);
        make.bottom.mas_equalTo(imageView.mas_bottom).offset(-22*base_H);
    }];
    
    UIImageView *yueImageView  = [[UIImageView alloc] init];
    yueImageView.image = [UIImage imageNamed:@"钱包"];
    [imageView addSubview:yueImageView];
    
    [yueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameImg.mas_right).offset(26*base_W);
        make.width.mas_equalTo(37*base_W);
        make.height.mas_equalTo(37*base_H);
        make.bottom.mas_equalTo(imageView.mas_bottom).offset(-11.5*base_H);
    }];
    
   
    self.heikaLab = [[UILabel alloc] init];
    self.heikaLab.backgroundColor = [UIColor colorWithHex:@"#4800C6"];
    self.heikaLab.font = [UIFont systemFontOfSize:11];
    self.heikaLab.textAlignment = NSTextAlignmentCenter;
    self.heikaLab.textColor = [UIColor whiteColor];
    self.heikaLab.text = self.heikaStr;
    [imageView addSubview:self.heikaLab];
    
    [self.heikaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yueLab.mas_right).offset(37*base_W);
        make.width.mas_equalTo(80*base_W);
        make.height.mas_equalTo(15.5*base_H);
        make.bottom.mas_equalTo(imageView.mas_bottom).offset(-22*base_H);
    }];
    
    UIImageView *kaiheikaImageView  = [[UIImageView alloc] init];
    kaiheikaImageView.image = [UIImage imageNamed:@"黑卡"];
    [imageView addSubview:kaiheikaImageView];
    
    __weak typeof(self)weakSelf = self;
    [kaiheikaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.heikaLab.mas_left).offset(-27.5*base_W);
        make.width.mas_equalTo(37*base_W);
        make.height.mas_equalTo(37*base_H);
        make.bottom.mas_equalTo(imageView.mas_bottom).offset(-11.5*base_H);
    }];
    
    [self bringSubviewToFront:kaiheikaImageView];
    
    self.GetImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(360, 5, 30, 30)];
    [imageView addSubview:self.GetImageView];
}
@end

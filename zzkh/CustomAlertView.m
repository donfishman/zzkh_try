//
//  CustomAlertView.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/15.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "CustomAlertView.h"
#import "Header.h"

//蓝色弹框

@implementation CustomAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView:frame];
    }
    return self;
}

- (void)createView:(CGRect)frame{
    [self.layer setCornerRadius:5.0];
    
    self.bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20*base_H, frame.size.width, frame.size.height-40*base_H)];
    [self addSubview:self.bgView];
    
    self.mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100*base_W,100*base_H)];
    self.mainView.center = self.bgView.center;
//    self.mainView.backgroundColor = [UIColor redColor];
    [self addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120*base_W);
        make.height.mas_equalTo(120*base_H);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.centerY.equalTo(self.bgView.mas_centerY).offset(-30*base_H);
    }];
    
    self.samllView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70*base_W,70*base_H)];
    [self.samllView.layer setCornerRadius:self.samllView.frame.size.width/2];
    self.samllView.clipsToBounds = YES;
//    self.samllView.center = self.mainView.center;
    [self addSubview:self.samllView];
    [self.samllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70*base_W);
        make.height.mas_equalTo(70*base_H);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.centerY.equalTo(self.bgView.mas_centerY).offset(-30*base_H);
    }];
    
    //黄色
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30*base_H)];
    self.headView.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headView.layer.mask = maskLayer;
    [self addSubview:self.headView];
    
    self.tittleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30*base_H)];
    self.tittleLab.center = self.headView.center;
    self.tittleLab.textAlignment = NSTextAlignmentCenter;
    self.tittleLab.textColor = [UIColor blackColor];
    self.tittleLab.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:self.tittleLab];
    
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-45*base_W, 0, 40*base_W, 30*base_H)];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    self.timeLab.textColor = [UIColor blackColor];
    self.timeLab.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:self.timeLab];
    
    self.mainLab = [[UILabel alloc] initWithFrame:CGRectMake(20*base_W, 180*base_H, frame.size.width-20*base_W, 30*base_H)];
    self.mainLab.textAlignment = NSTextAlignmentCenter;
    self.mainLab.textColor = [UIColor whiteColor];
    self.mainLab.font = [UIFont systemFontOfSize:14];
    [self.bgView addSubview:self.mainLab];
    
    self.introLab = [[UILabel alloc] initWithFrame:CGRectMake(40*base_W, 160*base_H, frame.size.width-80*base_W, 30*base_H)];
    self.introLab.textAlignment = NSTextAlignmentCenter;
    self.introLab.textColor = [UIColor whiteColor];
    self.introLab.font = [UIFont systemFontOfSize:14];
    [self.bgView addSubview:self.introLab];
    
}
@end

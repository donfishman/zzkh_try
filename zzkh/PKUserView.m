//
//  PKUserView.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/14.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "PKUserView.h"
#import "Header.h"
#import "Masonry.h"

@implementation PKUserView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化代码
        [self drawRectView:frame];
    }
    return self;
}

- (UIView *)drawRectView:(CGRect)frame{
    UIImageView *bigView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    bigView.layer.cornerRadius = 16;
    bigView.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
    [self addSubview:bigView];
    
    self.smallImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.smallImgView.center = bigView.center;
    self.smallImgView.image = [UIImage imageNamed:@"默认头像"];
    self.smallImgView.layer.cornerRadius = 15;
    self.smallImgView.clipsToBounds=YES;
    [bigView addSubview:self.smallImgView];
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 70, 25)];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 60, 20)];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.textColor = [UIColor whiteColor];
    self.nameLab = nameLab;
    [nameImageView addSubview:nameLab];
    [self addSubview:nameImageView];
    [self bringSubviewToFront:bigView];
    
    if ([[Single sharedInstance].str isEqualToString:@"left"]) {
        nameImageView.image = [UIImage imageNamed:@"左边-人物姓名卡片"];
        [nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
            make.centerY.equalTo(bigView);
            make.left.mas_equalTo(bigView.mas_left).offset(20);
            make.height.mas_equalTo(25);
        }];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nameImageView);
            make.centerY.equalTo(nameImageView);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
        }];
    }else{
        nameImageView.image = [UIImage imageNamed:@"右边-人物姓名卡片"];        
        [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(32);
            make.top.mas_equalTo(frame.origin.y);
        }];
        
        [nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
            make.centerY.equalTo(bigView);
            make.right.mas_equalTo(bigView.mas_right).offset(-20);
            make.height.mas_equalTo(25);
        }];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nameImageView);
            make.centerY.equalTo(nameImageView);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(17);
        }];
    }
    return self;
}

@end

//
//  BettalView.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/15.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "BettalView.h"
#import "UserImageView.h"
#import "Header.h"

@implementation BettalView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化代码
        [self drawRectIamgeView:frame];
    }
    return self;
}

-(void)drawRectIamgeView:(CGRect)frame{

    UIImageView *bigView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)];
    bigView.layer.cornerRadius = frame.size.width/2;
    bigView.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
    [self addSubview:bigView];
    
    self.smallImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-3, frame.size.height-23)];
    self.smallImgView.center = bigView.center;
    self.smallImgView.image = [UIImage imageNamed:@"默认头像"];
    self.smallImgView.layer.cornerRadius = (frame.size.width-3)/2;
    self.smallImgView.clipsToBounds=YES;
    
    [bigView addSubview:self.smallImgView];
    [self addSubview:bigView];
   self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 50, 20)];
//    self.nameLab.text = @"陈伟霆";
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.font = [UIFont systemFontOfSize:14];
    self.nameLab.textColor = [UIColor whiteColor];
    [self addSubview:self.nameLab];
    
    __weak typeof(self)weakSelf = self;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.smallImgView.mas_bottom);
        make.width.mas_equalTo(50);
        make.centerX.mas_equalTo(weakSelf.smallImgView.mas_centerX);
        make.height.mas_equalTo(20);
    }];
}
@end

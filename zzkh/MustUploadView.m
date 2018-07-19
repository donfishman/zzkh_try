//
//  MustUploadView.m
//  zzkh
//
//  Created by 智者开黑 on 2018/7/18.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "MustUploadView.h"
#import "Header.h"

@interface MustUploadView ()
@property (nonatomic,strong)UIView *baseView;
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)UILabel *titltLabel;
@end
@implementation MustUploadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];

        _baseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

        [self addSubview:_baseView];

        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 445*base_W, 289*base_H)];
        _alertView.layer.cornerRadius = 10;
        _alertView.clipsToBounds = YES;
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        gradientLayer2.frame = _alertView.frame;
        gradientLayer2.startPoint = CGPointMake(0, 0);
        gradientLayer2.endPoint = CGPointMake(1, 1);
        UIColor *startColor2 = [UIColor colorWithHex:@"#476DF4"];
        UIColor *endColor2 = [UIColor colorWithHex:@"#8036F1"];
        gradientLayer2.colors = @[(__bridge id)startColor2.CGColor,
                                  (__bridge id)endColor2.CGColor];
        gradientLayer2.locations = @[@(0.1f), @(1.0f)];
        gradientLayer2.cornerRadius = 10;
        [_alertView.layer addSublayer:gradientLayer2];
        [_baseView addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_baseView.mas_top).mas_offset(38.5*base_H);
            make.centerX.mas_equalTo(_baseView.mas_centerX);
            make.width.mas_equalTo(445*base_W);
            make.height.mas_equalTo(289*base_H);
        }];

        _titltLabel= [[UILabel alloc]init];
        _titltLabel.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
        _titltLabel.text = @"有新版本啦";
        _titltLabel.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:_titltLabel];
        [_titltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.mas_equalTo(_alertView);
            make.height.mas_equalTo(31.75*base_H);
        }];
    }
    return self;
    
}

-(void)drawRectWithStr:(NSString *)str
{

    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setImage:[UIImage imageNamed:@"3-4关闭"] forState:UIControlStateNormal];
    [[_cancleBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [_cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_cancleBtn];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_alertView.mas_top).offset(4.6*base_H);
        make.right.mas_equalTo(_alertView.mas_right).offset(-9.25*base_W);
        make.height.mas_equalTo(23*base_H);
        make.width.mas_equalTo(23*base_W);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"复活选择背景2"]];
    [_alertView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titltLabel.mas_bottom);
        make.width.left.mas_equalTo(_titltLabel);
        make.height.mas_equalTo((289 - 31.75)*base_H);
        
    }];
    
    UIImageView *midImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"0-1-弹出框插画-1"]];
    [_alertView addSubview:midImage];
    [midImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView);
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.width.mas_equalTo(180*base_W);
        make.height.mas_equalTo(139.5*base_H);
    }];
    
    UILabel *messageL = [[UILabel alloc]init];
//    WithFrame:CGRectMake(0, 0, 320*base_W, 40*base_H)
    messageL.numberOfLines = 0;
    messageL.textAlignment = NSTextAlignmentCenter;
    messageL.text = str;
    messageL.textColor = [UIColor whiteColor];
    CGSize size = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:messageL.font,NSFontAttributeName,nil]];
    [_alertView addSubview:messageL];
    [messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(midImage.mas_bottom);
        make.centerX.mas_equalTo(_alertView.mas_centerX);
        make.width.mas_equalTo(300*base_W);
        make.height.mas_equalTo(size.height*base_H);
    }];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBtn setBackgroundImage:[UIImage imageNamed:@"获胜-btn右-黄"] forState:UIControlStateNormal];
    [[updateBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [updateBtn setTitle:@"点我光速升级" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor colorWithHex:@"#34085F"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:updateBtn];
    
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_alertView.mas_bottom).offset(-36.5*base_H);
        make.height.mas_equalTo(43.5*base_H);
        make.width.mas_equalTo(174*base_W);
        make.centerX.mas_equalTo(_alertView.mas_centerX);
    }];
  
}

-(void)drawRectAboutSave
{
    _titltLabel.text = @"";
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"复活选择背景2"]];
    [_alertView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titltLabel.mas_bottom);
        make.width.left.mas_equalTo(_titltLabel);
        make.height.mas_equalTo((289 - 31.75)*base_H);
        
    }];
    
    UIImageView *midImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"0-1维修"]];
    [_alertView addSubview:midImage];
    [midImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_top).offset(31.9*base_H);
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.width.mas_equalTo(150*base_W);
        make.height.mas_equalTo(102*base_H);
    }];
    
    UILabel *messageL = [[UILabel alloc]init];
    //    WithFrame:CGRectMake(0, 0, 320*base_W, 40*base_H)
    messageL.numberOfLines = 0;
    messageL.textAlignment = NSTextAlignmentCenter;
    
    NSString *str =  @"程序员小哥哥正在努力搬砖搭建系统中";
    messageL.text = str;
    messageL.textColor = [UIColor whiteColor];
    CGSize size = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:messageL.font,NSFontAttributeName,nil]];
    [_alertView addSubview:messageL];
    [messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(midImage.mas_bottom).offset(10*base_H);
        make.centerX.mas_equalTo(_alertView.mas_centerX);
        make.width.mas_equalTo(_alertView.mas_width);
        make.height.mas_equalTo(size.height*base_H);
    }];
    
    
    UILabel *lateL = [[UILabel alloc]init];
    //    WithFrame:CGRectMake(0, 0, 320*base_W, 40*base_H)
    lateL.textAlignment = NSTextAlignmentCenter;
    NSString *str2 = @"请稍后再试～";
    lateL.text = str2;
    lateL.font = [UIFont systemFontOfSize:24];
    lateL.textColor = [UIColor whiteColor];
    [_alertView addSubview:lateL];
    [lateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(messageL.mas_bottom).offset(20*base_H);
        make.centerX.mas_equalTo(_alertView.mas_centerX);
        make.width.mas_equalTo(200*base_W);
        make.height.mas_equalTo(25*base_H);
    }];
    
    
    
    
    
    
}

-(void)updateAction
{
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",@"1014939463"];
                   
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}

-(void)cancleAction
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

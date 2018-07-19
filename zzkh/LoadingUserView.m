//
//  LoadingUserView.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/14.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "LoadingUserView.h"
#import "UserImageView.h"
#import "Header.h"
#import "LoadingViewController.h"

@implementation LoadingUserView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化代码
        [self drawRectView:frame];
    }
    return self;
}
- (void)drawRectView:(CGRect)frame{

    if ([[Single sharedInstance].str isEqualToString:@"left"]) {
            _isLeft = YES;
        }else{
            _isLeft = NO;
        }
    if (_isLeft) {
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,120, 40)];
        bgImageView.image = [UIImage imageNamed:@"蓝队bg"];
        [self addSubview:bgImageView];
        
        UIImageView *bigView = [[UIImageView alloc] initWithFrame:CGRectMake(100, -5, 52, 52)];
        bigView.layer.cornerRadius = 26;
        bigView.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
        [bgImageView addSubview:bigView];
        
        self.smallImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 50, 50)];
//        self.smallImgView.center = bigView.center;
        self.smallImgView.image = [UIImage imageNamed:@"默认头像"];
        self.smallImgView.layer.cornerRadius = 25;
        self.smallImgView.clipsToBounds=YES;

        [bigView addSubview:self.smallImgView];
    }else{
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,120, 40)];
        bgImageView.image = [UIImage imageNamed:@"绿队bg"];
        CGAffineTransform transform = CGAffineTransformMakeScale(-1,1);
        bgImageView.transform = transform;
        [self addSubview:bgImageView];
        UIImageView *bigView = [[UIImageView alloc] initWithFrame:CGRectMake(100, -5, 52, 52)];
        bigView.layer.cornerRadius = 26;
        bigView.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
        [bgImageView addSubview:bigView];
        
        self.smallImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 50, 50)];
//        self.smallImgView.image = [UIImage imageNamed:@"默认头像"];
        self.smallImgView.layer.cornerRadius = 25;
        self.smallImgView.clipsToBounds=YES;
        [bigView addSubview:self.smallImgView];
    }
    
}

@end

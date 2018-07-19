//
//  UserImage.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/13.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "UserImageView.h"
#import "Header.h"
@implementation UserImageView
//MARK: 初始化
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化代码
        [self drawRectIamgeView:frame];
    }
    return self;
}

//MARK:绘制图形
-(UIImageView *)drawRectIamgeView:(CGRect)frame{
    UIImageView *bigView = [[UIImageView alloc] initWithFrame:frame];
    bigView.layer.cornerRadius = frame.size.width/2;
    bigView.backgroundColor = [UIColor colorWithHex:@"#FFE348"];
    [self addSubview:bigView];
    
    self.smallImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-3, frame.size.width-3)];
    self.smallImgView.center = bigView.center;
    self.smallImgView.image = [UIImage imageNamed:@"默认头像"];
    self.smallImgView.layer.cornerRadius = (frame.size.width-3)/2;
    self.smallImgView.clipsToBounds=YES;
    
//    self.smallImgView.backgroundColor = [UIColor redColor];
    [bigView addSubview:self.smallImgView];
    return bigView;
}

@end

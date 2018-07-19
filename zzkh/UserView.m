//
//  UserView.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/14.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "UserView.h"
#import "Header.h"
#import "PKUserView.h"

@implementation UserView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化代码
        [self drawRectView];
    }
    return self;
}

// 正方形用户图像
- (void)drawRectView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
    view.backgroundColor = [UIColor colorWithHex:@"#4798F8"];
//    [self addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    imageView.image = [UIImage imageNamed:@"默认头像"];
    imageView.center = view.center;
//    [view addSubview:imageView];
    
    PKUserView *pkUserView = [[PKUserView alloc] initWithFrame:CGRectMake(0, 55, 65, 25)];
    [self addSubview:pkUserView];
    
    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(view);
//        make.centerY.equalTo(view);
//        make.width.mas_equalTo(130);
//        make.height.mas_equalTo(20);
//    }];
}
@end

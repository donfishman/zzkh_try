//
//  CustomProgressView.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/14.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "CustomProgressView.h"
#import "Header.h"

@interface CustomProgressView ()

/** 进度条*/
@property (nonatomic ,weak) UIView *progressView;
@property (nonatomic ,weak) UIImageView *progressImageView;

@end

@implementation CustomProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect  viewFrame = CGRectMake(0, 0, 0, frame.size.height);
        UIView *view = [[UIView alloc]initWithFrame:viewFrame];
        [self addSubview:view];
        view.backgroundColor = [UIColor clearColor];
        self.progressView = view;
        
        UIImageView *progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-60, -5,70, frame.size.height+15)];
//        progressImageView.backgroundColor = [UIColor orangeColor];
        progressImageView.image = [UIImage imageNamed:@"加载光"];
//        [self addSubview:progressImageView];
//        self.progressImageView = progressImageView;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    CGRect  viewFrame = CGRectMake(0, 0, 0, self.frame.size.height);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    [self addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    self.progressView = view;
}

-(void)setProgressFloat:(CGFloat)progressFloat{
    
    _progressFloat = progressFloat;
    if (progressFloat == 0) {
        self.progressView.backgroundColor = [UIColor clearColor];
    }else if(progressFloat >= 1){
        
    }else{
        self.progressView.backgroundColor = [UIColor colorWithHex:@"#F4F366"];
        self.progressView.layer.cornerRadius = 6;
        self.progressView.clipsToBounds = YES;
        CGRect frame = CGRectMake(0, 0, self.frame.size.width * progressFloat, self.frame.size.height);
        
        [UIView animateWithDuration:1.5 animations:^{            
            self.progressView.frame = frame;
        }];
        
        CGRect frame2 = CGRectMake(-55+self.frame.size.width * progressFloat, -10, 70, 30);
        [UIView animateWithDuration:1.5 animations:^{
            self.progressImageView.frame = frame2;
        }];
        
    }
}


@end

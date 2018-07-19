//
//  BackBtn.m
//  zzkh
//
//  Created by 智者开黑 on 2018/7/17.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "BackBtn.h"
#import "Header.h"

@implementation BackBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleF = CGRectMake(0, 0, 64*base_W, 22.5*base_H);
    CGRect imageF = CGRectMake(70*base_W, 0, 20*base_W, 22.5*base_H);
    
    titleF.origin.x = 0;
    self.titleLabel.frame = titleF;
    
    self.imageView.frame = imageF;
    
   
    
}

@end

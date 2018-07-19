//
//  HeadView.h
//  zzkh
//
//  Created by 旭鹏 on 2018/6/14.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView
@property (nonatomic, strong) UIImageView *GetImageView;
@property (nonatomic, strong) UILabel *heikaLab;
@property (nonatomic,copy)NSString *heikaStr;

- (void)drawRectView;
@end

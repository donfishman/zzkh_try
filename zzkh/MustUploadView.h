//
//  MustUploadView.h
//  zzkh
//
//  Created by 智者开黑 on 2018/7/18.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MustUploadView : UIView
@property(nonatomic,strong) UIButton *cancleBtn;

-(void)drawRectWithStr:(NSString *)str;
-(void)drawRectAboutSave;
@end

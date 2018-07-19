//
//  Header.h
//  zzkh
//
//  Created by 旭鹏 on 2018/6/11.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

//自定义库
#import "UIColor+Addition.h"

//第三方库
#import "Masonry.h"
#import "AFNetworking.h"

//播放器
#import "LGAudioPlayer.h"
#import <JavaScriptCore/JavaScriptCore.h>

//单利
#import "Single.h"

#define APPHostT @"https://socket.kai-hei.com/"//ceshi
#define APPHost @"https://socket.zzkaihei.com/"//zhengshi
#define APPHostH @"https://zzkh.zzkaihei.com/zzkhapi/"//zhengshi
#define APPHostTT @"https://zzkh.kai-hei.com/zzkhapi/"//zhengshi

//#define token @"XJLKAX eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1MzE2MjYxOTQsInN1YiI6IjY5IiwiY3JlYXRlZCI6MTUyOTAzNDE5NDY5N30.0dGAzBgRcBd4s0KDfOx4CaH30WbaKbW1DXyMHvuJLRDSf0l1yhpIxMovWpJR2Ha_9__JHUuELBke9VFMe0CmSg"

#define IPhone4_5_6_6P_X(a,b,c,d,e) (CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size) ?(a) :(CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size) ? (b) : (CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size) ?(c) : (CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size) ?(d) :(CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size) ?(e) : 0)))))

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

//#define base_W  [UIApplication sharedApplication].statusBarFrame.size.height > 20 ? [UIScreen mainScreen].bounds.size.width/812 : [UIScreen mainScreen].bounds.size.width/667
#define base_H [UIScreen mainScreen].bounds.size.height/375
#define base_W [UIScreen mainScreen].bounds.size.width/667

#endif /* Header_h */

//
//  scoketViewController.m
//  zzkh
//
//  Created by 旭鹏 on 2018/6/11.
//  Copyright © 2018年 旭鹏. All rights reserved.
//

#import "scoketViewController.h"
#import "GCDAsyncSocket.h"

@interface scoketViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong)GCDAsyncSocket *clientSocket;
@property (nonatomic, strong)UIButton *connectBtn;
@property (nonatomic, strong)UIButton *sendBtn;

@end

#define IP @"192.168.1.1"
#define PORT @"8888"

@implementation scoketViewController{
    
    int reconnection_time;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.connectBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.connectBtn setTitle:@"连接服务器" forState:UIControlStateNormal];
    [self.connectBtn setBackgroundColor:[UIColor orangeColor]];
    [self.connectBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.connectBtn];
    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    [self.sendBtn setTitle:@"发消息给服务器" forState:UIControlStateNormal];
    [self.sendBtn setBackgroundColor:[UIColor orangeColor]];
    [self.sendBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendBtn];
    
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)clickBtn:(UIButton *)sender{
    [self.clientSocket disconnect];
    NSError *err = nil;
    [self.clientSocket connectToHost:IP onPort:[PORT intValue] error:&err];
}

#pragma GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    //链接成功会收到服务器的回掉
    NSLog(@"连接成功");
    [sock readDataWithTimeout:-1 tag:200];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    //连接失败后会有失败回掉
     NSLog(@"连接失败");
    // 重连 (设置的重连规则是重连次数为5次，每次的时间间隔为2的n次方，超过次数之后，就不再去重连了)
    if (reconnection_time >= 0 && reconnection_time <= 5) {
        [self.clientSocket connectToHost:IP onPort:[PORT intValue] error:&err];
        reconnection_time++;
    }else{
        reconnection_time = 0;
    }
}

#pragma  mark --消息发送成功
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    NSLog(@"向服务器发送请求消息");
}

-  (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到服务器返回的数据 tcp [%@:%d] %@", ip, port, s);
    [self.clientSocket readDataWithTimeout:-1 tag:200];
}

- (void)sendMsg {
    // 写这里代码
    NSString *s = @"hello world";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    // 发送消息 这里不需要知道对象的ip地址和端口
    [self.clientSocket writeData:data withTimeout:60 tag:100];
}

- (void)dealloc {
    NSLog(@"dealloc");
    // 关闭套接字
    [self.clientSocket disconnect];
    self.clientSocket = nil;
}
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"Received bytes: %zd",partialLength);
}

@end

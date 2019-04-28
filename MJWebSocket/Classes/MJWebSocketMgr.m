//
//  MJWebSocketMgr.m
//  webrtc_podspes
//
//  Created by Yang Yu on 2019/4/23.
//  Copyright © 2019 Musjoy. All rights reserved.
//

#import "MJWebSocketMgr.h"
#import "MJWebSocket.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface MJWebSocketMgr() <MJSocketDelegate>

@property (nonatomic, strong) MJWebSocket *socket;

@property (nonatomic, strong) MJSocketConfig *config;
/// 当前重新连接的次数
@property (nonatomic, assign) NSInteger currentConnectCount;

@end

@implementation MJWebSocketMgr

#pragma mark- Init

- (instancetype)initWithConfig:(MJSocketConfig *)config delegate:(id <MJWebSocketMgrDelegate>)delegate {
    self = [super init];
    if (self) {
        self.config = config;
        self.delegatge = delegate;
        [self configWebSocket];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticReachabilityChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        _currentConnectCount = 0;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticReachabilityChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        _currentConnectCount = 0;
    }
    return self;
}

- (void)dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- Public

/// 开始连接
- (void)startConnect {
    if (self.socket) {
        [self.socket startConnect];
    } else {
        [self configWebSocket];
        [self.socket startConnect];
    }
}

/// 手动停止连接
- (void)stopConnect {
    [self.socket endConnect];
    self.socket = nil;
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)sendMessage:(id)message {
    [self.socket sendData:message];
}

#pragma mark- Private
/// 初始化SRWebSocket
- (void)configWebSocket {
    self.socket = [[MJWebSocket alloc] initWithIpString:self.config.serverURL];
    self.socket.delegate = self;
}

/// 监听网络变化
- (void)noticReachabilityChange:(NSNotification *)notification {
    
    AFNetworkReachabilityStatus status = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    
    if (status == AFNetworkReachabilityStatusReachableViaWiFi ||
        status == AFNetworkReachabilityStatusReachableViaWWAN) {
        [self reConnect];
    } else {
        // 连接失败
        // 网络断开时socket会断开, 已经在代理中重连了, 这里先不处理
    }
}

/// 连接成功
- (void)actionConnectSucceed {
    _currentConnectCount = 0;
}

/// 连接失败或中断等问题
- (void)actionConnectInterruption {
    [self reConnect];
}

/// 重连
- (void)reConnect {
 
    if (self.socket == nil) {
        return ;
    }
    
    if (self.socket.status == MJSocketStatusConnecting ||
        self.socket.status == MJSocketStatusConnected) {
        return ;
    }
    
    // 最大重连次数
    if (_currentConnectCount >= self.config.maxReConnectCount) {
        _currentConnectCount = 0;
        return ;
    }
    
    _currentConnectCount ++;
    
    int reConnecTime = 0;
    if (_currentConnectCount == 0) {
        reConnecTime = 2;
    } else {
        reConnecTime = pow(2, _currentConnectCount);
    }
//    NSLog(@"reConnecTime %ld %d", (long)_currentConnectCount, reConnecTime);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnecTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self startConnect];
    });
}

#pragma mark- MJSocketDelegate
/// 接收到消息
- (void)socket:(id<MJSocket>)socket didReceiveMessage:(id)message {
//    [[NSNotificationCenter defaultCenter] postNotificationName:MJWebSocketReceiveMessageNotification object:message];
    
    if (self.delegatge && [self.delegatge respondsToSelector:@selector(socket:didReceiveMessage:)]) {
        [self.delegatge socket:self didReceiveMessage:message];
    }
    
}

/// 连接成功
- (void)socketDidOpen:(id<MJSocket>)socket {
    [self actionConnectSucceed];
    
    if (self.delegatge && [self.delegatge respondsToSelector:@selector(socket:status:)]) {
        [self.delegatge socket:self status:_socket.status];
    }
}

/// 连接失败
- (void)socket:(id<MJSocket>)socket didFailWithError:(NSError *)error {
    [self actionConnectInterruption];
    
    if (self.delegatge && [self.delegatge respondsToSelector:@selector(socket:status:)]) {
        [self.delegatge socket:self status:_socket.status];
    }
}

/// 连接断开
- (void)socket:(id<MJSocket>)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self actionConnectInterruption];
    if (self.delegatge && [self.delegatge respondsToSelector:@selector(socket:status:)]) {
        [self.delegatge socket:self status:_socket.status];
    }
}

@end

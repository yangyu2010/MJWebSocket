//
//  MJWebSocket.m
//  webrtc_podspes
//
//  Created by Yang Yu on 2019/4/23.
//  Copyright © 2019 Musjoy. All rights reserved.
//

#import "MJWebSocket.h"
#import "SRWebSocket.h"

@interface MJWebSocket() <SRWebSocketDelegate>

/// webSocket
@property (nonatomic, strong) SRWebSocket *webSocket;

@end


@implementation MJWebSocket

#pragma mark- Init

- (instancetype)initWithIpString:(NSString *)ipString {
    self = [super init];
    if (self) {
        /// 初始化SRWebSocket
        self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:ipString]];
        self.webSocket.delegate = self;
        
        _status = MJSocketStatusUnConnected;
    }
    return self;
}


#pragma mark- MJSocket Delegate

- (void)startConnect {
    // 空值判断
    if (self.webSocket == nil) {
        return ;
    }
    
    // 已连接
    if (_status == MJSocketStatusConnecting ||
        _status == MJSocketStatusConnected) {
        return ;
    }
    
    if (self.webSocket.readyState == SR_OPEN) {
        // 已连接
        return ;
    }
    
    // 开始连接
    
    _status = MJSocketStatusConnecting;
    
    [self.webSocket open];
}

- (void)endConnect {
    if (self.webSocket == nil) {
        return ;
    }
    
    [self.webSocket close];
    self.webSocket = nil;
    _status = MJSocketStatusUnConnected;
}

- (void)sendData:(id)data {
    if (self.webSocket.readyState != SR_OPEN) {
        NSLog(@"sendData发送失败 webSocket 未连接❌❌❌");
        return ;
    }
    
    [self.webSocket send:data];
}

#pragma mark- Private

/// 连接成功
- (void)actionConnectSucceed {
//    NSLog(@"连接成功");
    _status = MJSocketStatusConnected;
}

/// 连接失败或中断等问题
- (void)actionConnectInterruption {
//    NSLog(@"连接失败");
    _status = MJSocketStatusUnConnected;
}


#pragma mark- SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(socket:didReceiveMessage:)]) {
        [self.delegate socket:self didReceiveMessage:message];
    }
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [self actionConnectSucceed];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketDidOpen:)]) {
        [self.delegate socketDidOpen:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self actionConnectInterruption];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(socket:didFailWithError:)]) {
        [self.delegate socket:self didFailWithError:error];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self actionConnectInterruption];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(socket:didCloseWithCode:reason:wasClean:)]) {
        [self.delegate socket:self didCloseWithCode:code reason:reason wasClean:wasClean];
    }
}



@end

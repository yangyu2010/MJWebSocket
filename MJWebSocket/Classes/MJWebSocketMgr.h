//
//  MJWebSocketMgr.h
//  webrtc_podspes
//
//  Created by Yang Yu on 2019/4/23.
//  Copyright © 2019 Musjoy. All rights reserved.
//  默认的管理类

#import <Foundation/Foundation.h>
#import "MJSocketConfig.h"
#import "MJSocketDelegate.h"
@class MJWebSocketMgr;

@protocol MJWebSocketMgrDelegate <NSObject>
/// 接收到消息
- (void)socket:(MJWebSocketMgr *)socket didReceiveMessage:(NSDictionary *)message;
/// 状态变更
- (void)socket:(MJWebSocketMgr *)socket status:(MJSocketStatus)status;
@end

NS_ASSUME_NONNULL_BEGIN

@interface MJWebSocketMgr : NSObject

@property (nonatomic, weak) id <MJWebSocketMgrDelegate> delegatge;

/// init
- (instancetype)initWithConfig:(MJSocketConfig *)config delegate:(id <MJWebSocketMgrDelegate>)delegate;

/// 开始连接
- (void)startConnect;
/// 手动停止连接
- (void)stopConnect;

- (void)sendMessage:(id)message;

@end

NS_ASSUME_NONNULL_END

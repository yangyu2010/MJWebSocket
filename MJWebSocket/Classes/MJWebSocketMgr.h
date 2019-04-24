//
//  MJWebSocketMgr.h
//  webrtc_podspes
//
//  Created by Yang Yu on 2019/4/23.
//  Copyright © 2019 Musjoy. All rights reserved.
//  默认的管理类

#import <Foundation/Foundation.h>
#import "MJSocketConfig.h"

FOUNDATION_EXPORT NSString * const MJWebSocketReceiveMessageNotification;
FOUNDATION_EXPORT NSString * const MJWebSocketStatusChangeNotification;

NS_ASSUME_NONNULL_BEGIN

@interface MJWebSocketMgr : NSObject

/// init
- (instancetype)initWithConfig:(MJSocketConfig *)config;

/// 开始连接
- (void)startConnect;
/// 手动停止连接
- (void)stopConnect;

- (void)sendMessage:(id)message;

@end

NS_ASSUME_NONNULL_END

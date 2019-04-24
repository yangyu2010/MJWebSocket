//
//  MJWebSocket.h
//  webrtc_podspes
//
//  Created by Yang Yu on 2019/4/23.
//  Copyright © 2019 Musjoy. All rights reserved.
//  WebSocket

#import <Foundation/Foundation.h>
#import "MJSocketDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJWebSocket : NSObject <MJSocket>

@property (nonatomic, assign) id<MJSocketDelegate> delegate;
@property (nonatomic, assign, readonly) MJSocketStatus status;

/// 初始化
- (instancetype)initWithIpString:(NSString *)ipString;

@end

NS_ASSUME_NONNULL_END

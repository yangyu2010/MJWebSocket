//
//  MJSocketConfig.h
//  webrtc_podspes
//
//  Created by Yang Yu on 2019/4/23.
//  Copyright © 2019 Musjoy. All rights reserved.
//  Socket配置

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJSocketConfig : NSObject

/// 服务器地址
@property (nonatomic, copy) NSString *serverURL;

/// 最大重连次数 一般6次
@property (nonatomic, assign) NSInteger maxReConnectCount;

@end

NS_ASSUME_NONNULL_END

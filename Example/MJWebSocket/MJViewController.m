//
//  MJViewController.m
//  MJWebSocket
//
//  Created by yangyu2010@aliyun.com on 04/24/2019.
//  Copyright (c) 2019 yangyu2010@aliyun.com. All rights reserved.
//

#import "MJViewController.h"
#import <MJWebSocket/MJWebSocketMgr.h>

@interface MJViewController ()

@property (nonatomic, strong) MJWebSocketMgr *mgr;

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    MJSocketConfig *config = [[MJSocketConfig alloc] init];
    config.serverURL = @"ws://localapp.musjoy.com:2345";
    config.maxReConnectCount = 5;
    
    self.mgr = [[MJWebSocketMgr alloc] initWithConfig:config];
    [self.mgr startConnect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:MJWebSocketReceiveMessageNotification object:nil];

}

- (void)receiveMessage:(NSNotification *)notification {
    NSLog(@"receiveMessage__ %@", notification.object);
    
    NSDictionary *dict = @{
                           @"type": [NSString stringWithFormat:@"%d", 000000],
                           };
    
    NSData *data= [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *strPing = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self.mgr sendMessage:strPing];
}


@end

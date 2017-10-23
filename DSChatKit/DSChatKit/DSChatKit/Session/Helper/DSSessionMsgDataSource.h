//
//  DSSessionMsgDataSource.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSession.h"
#import "DSSessionConfig.h"

//消息数据源
@interface DSSessionMsgDataSource : NSObject

/**
 初始化方法

 @param session 当前会话
 @param sessionConfig 会话配置信息
 @return 实例
 */
- (instancetype)initWithSession:(DSSession *)session config:(id<DSSessionConfig>)sessionConfig;

//会话配置
@property (nonatomic, weak) id<DSSessionConfig> sessionConfig;

//每页消息显示条数
@property (nonatomic, readonly) NSInteger messageLimit;

//两条消息隔多久显示时间戳
@property (nonatomic, readonly) NSInteger showTimeInterval;

@property (nonatomic, strong) NSMutableArray *items;

//数据对外接口
- (void)loadHistoryMessagesWithComplete:(void(^) (NSInteger index, NSArray *messages,NSError *error))handler;

@end

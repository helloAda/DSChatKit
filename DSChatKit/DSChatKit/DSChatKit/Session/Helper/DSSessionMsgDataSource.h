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

//数据存放
@property (nonatomic, strong) NSMutableArray *items;

//会话配置
@property (nonatomic, weak) id<DSSessionConfig> sessionConfig;

//每页消息显示条数
@property (nonatomic, readonly) NSInteger messageLimit;

//两条消息隔多久显示时间戳
@property (nonatomic, readonly) NSInteger showTimeInterval;

//复位消息
- (void)resetMessages:(void(^)(NSError *error))handle;

//数据对外接口 加载历史数据
- (void)loadHistoryMessagesWithComplete:(void(^) (NSInteger index, NSArray *messages,NSError *error))handler;

//返回model所在的index
- (NSInteger)indexAtModelArray:(DSMessageModel *)model;

//添加消息，会根据时间戳插入到相应位置
- (NSArray<NSNumber *> *)insertMessageModels:(NSArray*)models;

//添加消息，直接插入消息列表末尾
- (NSArray<NSNumber *> *)appendMessageModels:(NSArray *)models;

//删除消息
- (NSArray<NSNumber *> *)deleteMessageModel:(DSMessageModel *)model;

//根据范围批量删除消息
- (NSArray<NSNumber *> *)deleteModels:(NSRange)range;
@end

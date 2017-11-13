//
//  DSChatKitMessageProvider.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSMessageModel.h"


//返回的消息结果集 回调
typedef void(^DSChatKitMessageProvideHandler)(NSError *error, NSArray<DSMessage *> *messages);

@protocol DSChatKitMessageProvider <NSObject>


/**
 下拉加载数据 从服务器

 @param firstMessage 最上面的一条消息 - 最开始也会触发这个回调，此时firstMessage = nil
 @param handler 返回消息结果集的回调
 */
- (void)pullDownServer:(DSMessage *)firstMessage handler:(DSChatKitMessageProvideHandler)handler;


/**
 下拉加载数据 从本地db

 @param firstMessage 最上面的一条消息 - 最开始也会触发这个回调，此时firstMessage = nil
 @param session 当前会话
 @param limit 一次拉取的条数
 @param handler 返回的回调
 */
- (void)pullDownLocal:(DSMessage *)firstMessage messagesInSession:(DSSession *)session limit:(NSInteger)limit handler:(DSChatKitMessageProvideHandler)handler;


// 是否需要时间戳显示
- (BOOL)needTimetag;

@end

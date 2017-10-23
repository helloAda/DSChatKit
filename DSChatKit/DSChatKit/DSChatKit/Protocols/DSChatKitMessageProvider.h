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
 下拉加载数据

 @param firstMessage 最上面的一条消息 - 最开始也会触发这个回调，此时firstMessage = nil
 @param handler 返回消息结果集的回调
 */
- (void)pullDown:(DSMessage *)firstMessage handler:(DSChatKitMessageProvideHandler)handler;

// 是否需要时间戳显示
- (BOOL)needTimetag;

@end

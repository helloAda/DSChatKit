//
//  DSSessionConfigurateProtocol.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//


#ifndef DSSessionConfigurateProtocol_h
#define DSSessionConfigurateProtocol_h

#import "DSMessageModel.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DSSessionInteractorProtocolDelegate <NSObject>

/**
 注意：
 这里多一个 发送已读回执的代理方法 是为了实现解耦
 详情见 DSSessionInteractor.m中 通知的 //程序从后台激活
 */
- (void)sendMessageReceipt:(DSMessage *)message;

// 消息为附件,并且附件是没有下载的状态 会执行该代理
- (void)checkAttachmentState:(DSMessage *)messages;

// 用户信息更新后 刷新数据
- (void)didRefreshMessageData;
// 获取消息数据之后 刷新数据
- (void)didFetchMessageData;

@end

@protocol DSSessionInteractorProtocol <NSObject>

//    --------  网络操作  --------
//发送已读回执
- (void)sendMessageReceipt:(NSArray *)messages complete:(void(^)(DSMessage *))complete;

//    --------  界面操作  --------

//从后面插入消息
- (void)addMessages:(NSArray *)messages;
//从中间插入消息
- (void)insertMessages:(NSArray *)messages;
//更新消息
- (DSMessageModel *)updateMessage:(DSMessage *)message;
//删除消息
- (DSMessageModel *)deleteMessage:(DSMessage *)message;

//    --------  数据操作  --------

//数据
- (NSArray *)items;
//找到DSMessage对应的DSMessageModel
- (DSMessageModel *)findMessageModel:(DSMessage *)message;
//是否需要处理已读回执
- (BOOL)shouldHandleReceipt;
//检查已读回执
- (void)checkReceipt;
//复位消息
- (void)resetMessage;
//加载历史消息
- (void)loadMessages:(void (^)(NSArray *messages,NSError *error))handler;


//    --------  排版操作  --------

//复位布局
- (void)resetLayout;
//改变键盘高度
- (void)changeLayout:(CGFloat)inputHeight;


//    --------  页面状态同步操作  --------

//界面将要出现的时候 刷新一下布局
- (void)onViewWillAppear;

@end
#endif

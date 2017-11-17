//
//  DSMessage.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSession.h"

//消息发送状态
typedef NS_ENUM(NSInteger, DSMessageSendStatus) {
    DSMessageSendStatusFailed,   // 发送失败
    DSMessageSendStatusSending,  // 发送中
    DSMessageSendStatusSuccess,  // 发送成功
};

typedef NS_ENUM(NSInteger, DSMessageAttachmentDownloadState) {
    DSMessageAttachmentDownloadStateNotDownload,  //有附件还没有下载过
    DSMessageAttachmentDownloadStateFailed,       //有附件但是下载失败了
    DSMessageAttachmentDownloadStateDownloading,  //有附件正在下载
    DSMessageAttachmentDownloadStateDownloaded,  //有附件下载成功 / 无附件
};

@interface DSMessage : NSObject

//消息发送时间
@property (nonatomic, assign) NSTimeInterval timestamp;

//消息id,唯一标识
@property (nonatomic, copy, readonly) NSString *messageID;

//消息所属会话
@property (nonatomic, nonatomic, copy, readonly) DSSession *session;

//消息附件下载状态 仅针对收到的消息
@property (nonatomic, assign, readonly) DSMessageAttachmentDownloadState attachmentDownloadState;

//是否是收到的消息 用于消息出错时需要重发还是重收
@property (nonatomic, assign , readonly) BOOL isReceivedMsg;

//是否是发送出去的消息 用于判断头像排版的位置
@property (nonatomic, assign, readonly) BOOL isSendMsg;

/**
 对方是否已读
 只有单聊消息，并且消息的isSendMsg = YES这个字段才有效，需要对方调用过发送已读回执的接口
 */
@property (nonatomic, assign, readonly) BOOL isRemoteRead;

//消息是否已经删除 
@property (nonatomic, assign, readonly) BOOL isDeleted;


@end

//
//  DSChatKitInfoFetchOption.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/22.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSSession;
@class DSMessage;
@interface DSChatKitInfoFetchOption : NSObject

//所属会话
@property (nonatomic, strong) DSSession *session;
//所属消息
@property (nonatomic, strong) DSMessage *message;
//屏蔽备注名
@property (nonatomic, assign) BOOL forbidaAlias;

@end

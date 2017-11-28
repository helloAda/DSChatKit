//
//  DSMessageObject.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGlobalDefs.h"

NS_ASSUME_NONNULL_BEGIN

@class DSMessage;

//消息体协议
@protocol DSMessageObject <NSObject>

//消息体所在的消息对象
@property (nullable,nonatomic, weak) DSMessage *message;

//消息内容类型
- (DSMessageType)type;

@end

NS_ASSUME_NONNULL_END

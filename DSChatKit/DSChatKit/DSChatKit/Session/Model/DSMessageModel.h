//
//  DSMessageModel.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSMessage.h"

@interface DSMessageModel : NSObject

//消息数据
@property (nonatomic, strong) DSMessage *message;

//时间戳
@property (nonatomic, readonly) NSTimeInterval messageTime;

//是否需要展示已读Lable;
@property (nonatomic) BOOL shouldShowReadLabel;


/**
 DSMessage封装成DSMessageModel

 @param message 消息体
 @return 实例
 */
- (instancetype)initWithMessage:(DSMessage *)message;

@end

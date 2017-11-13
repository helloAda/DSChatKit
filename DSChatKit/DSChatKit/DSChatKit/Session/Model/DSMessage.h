//
//  DSMessage.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSMessage : NSObject

//消息发送时间
@property (nonatomic, assign) NSTimeInterval timestamp;

//消息id,唯一标识
@property (nonatomic, copy,readonly) NSString *messageID;

@end

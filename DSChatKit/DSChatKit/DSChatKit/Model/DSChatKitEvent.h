//
//  DSChatKitEvent.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/21.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSMessageModel.h"

@interface DSChatKitEvent : NSObject

//事件名
@property (nonatomic, copy) NSString *eventName;
//消息数据模型
@property (nonatomic, strong) DSMessageModel *messageModel;
//其它数据
@property (nonatomic, strong) id data;

@end


extern NSString *const DSChatKitEventNameTapLabelLink;

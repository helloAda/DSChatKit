//
//  DSSession.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DSSessionType) {
    DSSessionTypeSingle = 0,  //一对一
    DSSessionTypeGroup  = 1    //群聊
};

//会话对象
@interface DSSession : NSObject

//会话id
@property (nonatomic, copy, readonly) NSString *sessionID;
//会话类型
@property (nonatomic, assign, readonly) DSSessionType sessionType;

//初始化
+ (instancetype)session:(NSString *)sessionID type:(DSSessionType)type;

@end

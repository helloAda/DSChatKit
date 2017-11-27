//
//  DSChatKitUtil.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/22.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSMessage;
@interface DSChatKitUtil : NSObject

//展示用户的昵称
+ (NSString *)showNick:(NSString *)uid inMessage:(DSMessage *)message;

//展示时间戳
+ (NSString *)showTime:(NSTimeInterval)msglastTime showDetail:(BOOL)showDetail;

@end

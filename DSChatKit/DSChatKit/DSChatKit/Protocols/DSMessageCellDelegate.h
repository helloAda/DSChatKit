//
//  DSMessageCellDelegate.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSMessageModel;
@class DSMessage;
@class DSChatKitEvent;

@protocol DSMessageCellDelegate <NSObject>

@optional
#pragma mark -- 点击事件
//点击cell
- (BOOL)tapCell:(DSChatKitEvent *)event;
//长按cell
- (BOOL)longPressCell:(DSMessage *)message inView:(UIView *)view;
//点击头像
- (BOOL)tapAvatar:(NSString *)userId;
//长按头像
- (BOOL)longPressAvatar:(NSString *)userId;
//重发消息
- (void)retryMessage:(DSMessage *)message;


//语音是否被播放了
- (BOOL)disableaudioPlayedStatusIcon:(DSMessage *)message;
@end


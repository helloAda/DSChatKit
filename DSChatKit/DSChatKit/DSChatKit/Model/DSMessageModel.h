//
//  DSMessageModel.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DSMessage.h"

//这个类主要是用于cell的数据模型
@interface DSMessageModel : NSObject

//消息数据
@property (nonatomic, strong) DSMessage *message;

//时间戳
@property (nonatomic, readonly) NSTimeInterval messageTime;
//气泡内容距离气泡的内边距
@property (nonatomic, readonly) UIEdgeInsets contentViewInsets;
//气泡距离cell的内边距
@property (nonatomic, readonly) UIEdgeInsets  bubbleViewInsets;
//是否显示昵称
@property (nonatomic, readonly) BOOL shouldShowNickName;
//是否显示头像
@property (nonatomic, readonly) BOOL shouldShowAvatar;
//是否需要展示已读Lable;
@property (nonatomic, assign) BOOL shouldShowReadLabel;
//头像距离cell
@property (nonatomic, readonly) CGFloat avatarMargin;
//头像是否显示在左边
@property (nonatomic, readonly) BOOL shouldShowLeft;
//昵称距离cell
@property (nonatomic, readonly) CGFloat nickNameMargin;

/**
 DSMessage封装成DSMessageModel

 @param message 消息体
 @return 实例
 */
- (instancetype)initWithMessage:(DSMessage *)message;

//计算内容大小
- (CGSize)contentSize:(CGFloat)width;

@end

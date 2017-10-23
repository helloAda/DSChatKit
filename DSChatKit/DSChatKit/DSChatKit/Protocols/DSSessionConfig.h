//
//  DSSessionConfig.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/7.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSMediaItem.h"
#import "DSInputEmojiManager.h"
#import "DSChatKitMessageProvider.h"

@protocol DSSessionConfig <NSObject>

@optional
//在点击 聊天输入框 +按钮 之后显示多媒体按钮
- (NSArray<DSMediaItem *> *)mediaItems;

//多添加的表情包
- (NSArray <DSInputEmojiCatalog *> *)emoticons;

//按钮类型 DSInputToolViewItemType 按顺序排列
- (NSArray <NSNumber *> *)inputToolViewItemTypes;

//是否需要显示输入框，若有实现 3DTouch 则这里配置成不显示
- (BOOL)isShowInputView;

//inputView 最多输入多长的字符 没实现则为1000
- (NSInteger)maxTextLength;

//聊天界面每页消息显示条数
- (NSInteger)messageLimit;

//两条消息间隔多久显示时间戳
- (NSTimeInterval)showTimestampInterval;

// 消息数据提供器 如果不实现则读取本地聊天记录
- (id<DSChatKitMessageProvider>)messageDataProvider;
@end

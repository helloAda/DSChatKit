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

@end

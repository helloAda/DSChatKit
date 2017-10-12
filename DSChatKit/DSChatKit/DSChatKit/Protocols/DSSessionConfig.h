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

@end

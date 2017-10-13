//
//  DSInputEmojiButton.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/13.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSInputEmojiManager.h"

@protocol DSEmojiButtonDelegate <NSObject>

//选择该表情
- (void)selectedEmoji:(DSInputEmoji *)emoji catalogID:(NSString *)catalogID;

@end

@interface DSInputEmojiButton : UIButton

//表情数据
@property (nonatomic, strong) DSInputEmoji *emojiData;
//表情所在目录id
@property (nonatomic, copy) NSString *catalogID;

@property (nonatomic, weak) id<DSEmojiButtonDelegate> delegate;

//初始化
+ (DSInputEmojiButton *)emojiButtonWithData:(DSInputEmoji *)data catalogID:(NSString *)catalogID delegate:(id<DSEmojiButtonDelegate>)delegate;
//按钮点击事件 暴露出来提供给删除键
- (void)buttonClick:(UIButton *)btn;
@end

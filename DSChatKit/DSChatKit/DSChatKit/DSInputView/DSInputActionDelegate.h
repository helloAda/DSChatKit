//
//  DSInputActionDelegate.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/18.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DSMediaItem;
@class DSInputView;

@protocol DSInputActionDelegate <NSObject>
@optional

//更多中 按钮的点击事件
- (BOOL)didTapMediaItem:(DSMediaItem *)item;
//开始录音
- (void)startRecording;
//停止录音
- (void)stopRecording;
//取消录音
- (void)cancelRecording;

//发送text及@的人
- (void)sendText:(NSString *)text atUsers:(NSArray *)atUsers;
//文本发生改变
- (void)textChange:(DSInputView *)inputView;
//发送非emoji表情 (表情包)
- (void)selectEmoticon:(NSString *)emoticonID catalog:(NSString *)catalogID;
//点击了添加表情按钮
- (void)selectAddBtn:(UIButton *)btn;

@end

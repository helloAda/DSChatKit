//
//  DSInputView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSInputToolView.h"
#import "DSInputMoreView.h"
#import "DSInputEmojiView.h"
#import "DSInputAtCache.h"

@protocol DSInputViewDelegate <NSObject>

@optional
//显示键盘
- (void)showInputView;
//隐藏键盘
- (void)hideInputView;
//改变高度 是否显示inputView
- (void)inputViewSizeToHeight:(CGFloat)height showInputView:(BOOL)show;
//输入@需要弹出选择联系人界面
- (void)inputAtshowSelectView;

@end

@interface DSInputView : UIView

//工具栏
@property (nonatomic, strong) DSInputToolView *toolView;
//更多 '+'  视图
@property (nonatomic, strong) DSInputMoreView *moreView;
//表情 '😊' 视图
@property (nonatomic, strong) DSInputEmojiView *emojiView;
//是否正在记录语音
@property (nonatomic, assign) BOOL recording;
//默认文字  '输入消息'
@property (nonatomic, copy) NSString *placeholder;
//最多字数限制 1000
@property (nonatomic, assign) NSInteger maxTextLength;
//@功能
@property (nonatomic, strong) DSInputAtCache *atCache;

/**
 初始化

 @param frame 位置大小
 @param config 配置信息
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame config:(id<DSSessionConfig>)config;

//设置代理
- (void)setInputDelegate:(id<DSInputViewDelegate>)delegate;
//点击事件代理
- (void)setActionDelegate:(id<DSInputActionDelegate>)actionDelegate;

//重新刷新状态
- (void)reset;
//刷新当前键盘状态
- (void)refreshStatus:(DSInputToolStatus)status;
//更新语音时间
- (void)updateAudioRecordTime:(NSTimeInterval)time;
@end

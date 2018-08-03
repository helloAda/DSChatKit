//
//  DSInputToolView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮类型  --  类似微信键盘，在朋友圈只需要表情按钮
typedef NS_ENUM(NSInteger, DSInputToolViewItemType){
    DSInputToolViewItemTypeVoice,         //声音
    DSInputToolViewItemTypeText,          //文本
    DSInputToolViewItemTypeEmoji,         //表情
    DSInputToolViewItemTypeMore,          //更多
};

//选中状态
typedef NS_ENUM(NSInteger, DSInputToolStatus) {
    
    DSInputToolStatusText,      // - 文字
    DSInputToolStatusAudio,     // - 声音
    DSInputToolStatusEmoji,     // - 表情
    DSInputToolStatusMore       // - 更多
    
};

@protocol DSInputToolViewDelegate <NSObject>

@optional
//将要被编辑
- (BOOL)textViewShouldBeginEditing;
//已经结束编辑
- (void)textViewDidEndEditing;
//文本将要发生改变
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;
//文本已经发生改变
- (void)textViewDidChange;
//toolView将要改变高度
- (void)toolViewWillChangeHeight:(CGFloat)height;
//toolView已经改变高度
- (void)toolViewDidChangeHeight:(CGFloat)height;

@end

@interface DSInputToolView : UIView

//声音按钮
@property (nonatomic, strong) UIButton *voiceBtn;

//表情按钮
@property (nonatomic, strong) UIButton *emojiBtn;

//更多按钮
@property (nonatomic, strong) UIButton *moreBtn;

//记录声音按钮
@property (nonatomic, strong) UIButton *recordBtn;

//输入文字框的背景图片
@property (nonatomic, strong) UIImageView *inputTextBackImage;

//输入的文字
@property (nonatomic, copy) NSString *contentText;

//代理
@property (nonatomic, weak) id<DSInputToolViewDelegate> delegate;

//是否显示键盘
@property (nonatomic, assign) BOOL showsKeyboard;

//按钮对应key数组
@property (nonatomic, strong) NSArray<NSNumber *> *inputToolViewItemTypes;

//更新状态
- (void)update:(DSInputToolStatus)status;

@end

@interface DSInputToolView (inputText)
//选中范围
- (NSRange)selectedRange;
//设置占位文本
- (void)setPlaceHolder:(NSString *)placeHolder;
//插入文本
- (void)insertText:(NSString *)text;
//删除文本
- (void)deleteText:(NSRange)range;

@end

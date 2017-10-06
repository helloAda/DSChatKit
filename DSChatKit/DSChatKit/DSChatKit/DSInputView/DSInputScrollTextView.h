//
//  DSInputScrollTextView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/30.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSInputScrollTextView;

@protocol DSInputScrollTextViewDelegate <NSObject>

@optional

//将要改变高度
- (void)willChangeHeight:(CGFloat)height;
//已经改变高度
- (void)didChangeHeight:(CGFloat)height;
//文本将要发生改变
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;
//是否允许对文本中的URL进行操作
- (BOOL)shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)range;
//是否允许对文本中的富文本进行操作
- (BOOL)shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)range;
//已经开始编辑
- (void)textViewDidBeginEditing:(DSInputScrollTextView *)scrollTextView;
// 焦点发生改变
- (void)textViewDidChangeSelection:(DSInputScrollTextView *)scrollTextView;
//已经结束编辑
- (void)textViewDidEndEditing:(DSInputScrollTextView *)scrollTextView;
//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(DSInputScrollTextView *)scrollTextView;
//将要结束编辑
- (BOOL)textViewShouldEndEditing:(DSInputScrollTextView *)scrollTextView;
// 文本发生改变
- (void)textViewDidChange:(DSInputScrollTextView *)scrollTextView;
@end

@interface DSInputScrollTextView : UIScrollView

//代理
@property (nonatomic,weak) id<DSInputScrollTextViewDelegate> textViewDelegate;

//最少行数
@property (nonatomic, assign) NSInteger minNumOfLines;

//最多行数
@property (nonatomic, assign) NSInteger maxNumOfLines;

//输入框
@property (nonatomic, strong) UIView *inputView;

@end



@interface DSInputScrollTextView (TextView)

//占位文本
@property (nonatomic, copy) NSAttributedString *placeholderAttributedText;

//输入的文字
@property (nonatomic, copy) NSString *text;

//字体
@property (nonatomic, strong) UIFont *font;

//字体颜色
@property (nonatomic, strong) UIColor *textColor;

//对齐方式
@property (nonatomic, assign) NSTextAlignment textAlignment;

//选中范围
@property (nonatomic, assign) NSRange selectedRange;

//检测内容
@property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;

//是否允许编辑
@property (nonatomic, assign) BOOL editable;

//是否允许选中
@property (nonatomic, assign) BOOL selectable;

//是否允许编辑富文本
@property (nonatomic, assign) BOOL allowsEditingTextAttributes;

//富文本
@property (nonatomic, copy)   NSAttributedString *attributedText;

//与键盘一起响应的View 有需要直接添加在这里即可
@property (nonatomic, strong) UIView *textViewInputAccessoryView;

//是否设置清除按钮
@property (nonatomic, assign) BOOL clearsOnInsertion;

//文本容器内边距
@property (nonatomic, assign) UIEdgeInsets textContainerInset;

//文本能排版的区域
@property (nonatomic, readonly) NSTextContainer *textContainer;

//文字内容的排版布局
@property (nonatomic, readonly) NSLayoutManager *layoutManager;

//文字内容
@property (nonatomic, readonly) NSTextStorage *textStorage;

//链接文本的样式
@property (nonatomic, copy) NSDictionary<NSString *, id> *linkTextAttributes;

//返回键样式
@property (nonatomic,assign)  UIReturnKeyType returnKeyType;

// 滚动可见范围
- (void)scrollRangeToVisible:(NSRange)range;

@end

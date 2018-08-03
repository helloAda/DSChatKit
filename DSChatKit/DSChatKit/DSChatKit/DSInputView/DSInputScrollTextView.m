//
//  DSInputScrollTextView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/30.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputScrollTextView.h"
#import "DSInputTextView.h"
#import "UIView+DSCategory.h"

#define FONTSIZE 16

@interface DSInputScrollTextView () <UITextViewDelegate>
//textView
@property (nonatomic, strong) DSInputTextView *textView;
//最大高度 根据最大行数maxNumOfLines而定
@property (nonatomic, assign) CGFloat maxHeight;
//最小高度 默认为初始化时的高度
@property (nonatomic, assign) CGFloat minHeight;
//保存上一次的frame
@property (nonatomic, assign) CGRect previousFrame;

@end

@implementation DSInputScrollTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[DSInputTextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //保存上一次的frame
        self.previousFrame = frame;
        [self setup];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //如果现在的宽度和上一次的保存的宽度不一样，计算新的frame
    if (self.previousFrame.size.width != self.bounds.size.width) {
        self.previousFrame = self.frame;
        [self fitToScrollView];
    }
}

//计算固有大小
- (CGSize)intrinsicContentSize
{
    return [self measureFrame:[self.textView sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)]].size;
}

#pragma mark - UIResponder

- (UIView *)inputView
{
    return self.textView.inputView;
}

- (void)setInputView:(UIView *)inputView
{
    self.textView.inputView = inputView;
}

- (BOOL)isFirstResponder {
    
    return self.textView.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textView resignFirstResponder];
}

#pragma mark -- set
//设置最小行数
- (void)setMinNumOfLines:(NSInteger)minNumOfLines {
    if (minNumOfLines <= 0) {
        self.minHeight = 0;
        return;
    }
    self.minHeight = [self simulateHeight:minNumOfLines];
    minNumOfLines = minNumOfLines;
}

//设置最大行数
- (void)setMaxNumOfLines:(NSInteger)maxNumOfLines {
    if (maxNumOfLines <= 0) {
        self.maxHeight = 0;
        return;
    }
    self.maxHeight = [self simulateHeight:maxNumOfLines];
    _maxNumOfLines = maxNumOfLines;
}

#pragma mark - Private

//初始化
- (void)setup {
    self.textView.delegate = self;
    //禁止滚动
    self.textView.scrollEnabled = NO;
    self.textView.font = [UIFont systemFontOfSize:FONTSIZE];
    self.textView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textView];
    self.minHeight = self.height;
    self.maxNumOfLines = 3;
    self.showsVerticalScrollIndicator = NO;
}

//计算最大最小高度
- (CGFloat)simulateHeight:(NSInteger)line {
    //先将旧的字符串保存起来
    NSString *saveText = self.textView.text;
    NSMutableString *newText = [NSMutableString stringWithFormat:@"-"];
    //先取消代理并隐藏
    self.textView.delegate = nil;
    self.textView.hidden = YES;
    //追加换行字符
    for (NSInteger index = 0; index < line; index++) {
        [newText appendString:@"\n|W|"];
    }
    //将换行符赋给text然后计算换行的高度
    self.textView.text = newText;
    
    CGFloat textViewMargin = 16;
    //计算后的高度 扣掉textViewMargin 和 contentInset.top contentInset.bottom
    CGFloat height = [self.textView sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)].height - (textViewMargin + self.textView.contentInset.top + self.textView.contentInset.bottom);
    //将旧文字赋给text，并设置代理
    self.textView.text = saveText;
    self.textView.hidden = NO;
    self.textView.delegate = self;
    return height;
    
}

//适应ScrollView
- (void)fitToScrollView {
    //是否在底部了
    BOOL scrollToBottom = self.contentOffset.y == self.contentSize.height - self.height;
    //设置textView的Frame
    CGSize actualTextViewSize = [self.textView sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    self.textView.height = actualTextViewSize.height;
    self.contentSize = actualTextViewSize;
    
    CGRect oldScrollViewFrame = self.frame;
    CGRect newScrollViewFrame = [self measureFrame:actualTextViewSize];
    
    //将要改变高度
    if (oldScrollViewFrame.size.height != newScrollViewFrame.size.height && newScrollViewFrame.size.height <= self.maxHeight) {
        if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(willChangeHeight:)]) {
            [self.textViewDelegate willChangeHeight:newScrollViewFrame.size.height];
        }
    }
    //改变frame, 其实只改变了高度
    self.frame = newScrollViewFrame;
    
    if (scrollToBottom) {
        [self scrollToBottom];
    }
    
    //已经改变高度
    if (oldScrollViewFrame.size.height != newScrollViewFrame.size.height && newScrollViewFrame.size.height <= self.maxHeight) {
        if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(didChangeHeight:)]) {
            [self.textViewDelegate didChangeHeight:newScrollViewFrame.size.height];
        }
    }
    
    //让视图知道下次布局时需要重新计算
    [self invalidateIntrinsicContentSize];
    
}

// 计算高度
- (CGRect)measureFrame:(CGSize)contentSize {
    CGSize newSize;
    //如果当前内容高度小于最小高度 或者没有文字 则为最小高度
    if (contentSize.height < self.minHeight || !self.textView.hasText) {
        newSize = CGSizeMake(contentSize.width, self.minHeight);
    //如果当前内容高度大于最大高度且大于0 则为最大高度
    }else if (self.maxHeight > 0 && contentSize.height > self.maxHeight) {
        newSize = CGSizeMake(contentSize.width, self.maxHeight);
    }else {
        newSize = contentSize;
    }
    CGRect newFrame = self.frame;
    newFrame.size.height = newSize.height;
    return newFrame;
}

//滚动到底部
- (void)scrollToBottom {
    CGPoint offset = self.contentOffset;
    self.contentOffset = CGPointMake(offset.x, self.contentSize.height - self.height);
}

#pragma mark -- UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        return [self.textViewDelegate shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(shouldInteractWithURL:inRange:)]) {
        return [self.textViewDelegate shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(shouldInteractWithTextAttachment:inRange:)]) {
        return [self.textViewDelegate shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.textViewDelegate textViewDidBeginEditing:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.textViewDelegate textViewDidChangeSelection:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.textViewDelegate textViewDidEndEditing:self];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.textViewDelegate textViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.textViewDelegate textViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textViewDelegate textViewDidChange:self];
    }
    [self fitToScrollView];
}
@end


@implementation DSInputScrollTextView (TextView)

@dynamic layoutManager;

- (NSAttributedString *)placeholderAttributedText
{
    return self.textView.placeholderAttributedText;
}

- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText
{
    [self.textView setPlaceholderAttributedText:placeholderAttributedText];
}

- (NSString *)text
{
    return self.textView.text;
}

- (void)setText:(NSString *)text
{
    self.textView.text = text;
    [self fitToScrollView];
}

- (UIFont *)font
{
    return self.textView.font;
}

- (void)setFont:(UIFont *)font
{
    self.textView.font = font;
}

- (UIColor *)textColor
{
    return self.textView.textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textView.textColor = textColor;
}

- (NSTextAlignment)textAlignment
{
    return self.textView.textAlignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.textView.textAlignment = textAlignment;
}

- (NSRange)selectedRange
{
    return self.textView.selectedRange;
}

- (void)setSelectedRange:(NSRange)selectedRange
{
    self.textView.selectedRange = selectedRange;
}

- (UIDataDetectorTypes)dataDetectorTypes
{
    return self.textView.dataDetectorTypes;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes
{
    self.textView.dataDetectorTypes = dataDetectorTypes;
}


- (BOOL)editable
{
    return self.textView.editable;
}

- (void)setEditable:(BOOL)editable
{
    self.textView.editable = editable;
}

- (BOOL)selectable
{
    return self.textView.selectable;
}

- (void)setSelectable:(BOOL)selectable
{
    self.textView.selectable = selectable;
}

- (BOOL)allowsEditingTextAttributes
{
    return self.allowsEditingTextAttributes;
}

- (void)setAllowsEditingTextAttributes:(BOOL)allowsEditingTextAttributes
{
    self.textView.allowsEditingTextAttributes = allowsEditingTextAttributes;
}

- (NSAttributedString *)attributedText
{
    return self.textView.attributedText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    self.textView.attributedText = attributedText;
    [self fitToScrollView];
}

- (UIView *)textViewInputAccessoryView
{
    return self.textView.inputAccessoryView;
}

- (void)setTextViewInputAccessoryView:(UIView *)textViewInputAccessoryView
{
    self.textView.inputAccessoryView = textViewInputAccessoryView;
}

- (BOOL)clearsOnInsertion
{
    return self.textView.clearsOnInsertion;
}

- (void)setClearsOnInsertion:(BOOL)clearsOnInsertion
{
    self.textView.clearsOnInsertion = clearsOnInsertion;
}

- (NSTextContainer *)textContainer
{
    return self.textView.textContainer;
}


- (UIEdgeInsets)textContainerInset
{
    return self.textView.textContainerInset;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    self.textView.textContainerInset = textContainerInset;
}

- (NSLayoutManager *)layoutManger
{
    return self.textView.layoutManager;
}

- (NSTextStorage *)textStorage
{
    return self.textView.textStorage;
}

- (NSDictionary<NSString *,id> *)linkTextAttributes
{
    return self.textView.linkTextAttributes;
}

- (void)setLinkTextAttributes:(NSDictionary<NSString *,id> *)linkTextAttributes
{
    self.textView.linkTextAttributes = linkTextAttributes;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    [self.textView setReturnKeyType:returnKeyType];
}

- (UIReturnKeyType)returnKeyType
{
    return self.textView.returnKeyType;
}

- (void)scrollRangeToVisible:(NSRange)range
{
    [self.textView scrollRangeToVisible:range];
}
@end

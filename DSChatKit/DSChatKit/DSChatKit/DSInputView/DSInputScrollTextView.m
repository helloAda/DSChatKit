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

@property (nonatomic, strong) DSInputTextView *textView;

@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, assign) CGFloat minHeight;

@property (nonatomic, assign) CGRect previousFrame;

@end

@implementation DSInputScrollTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.textView = [[DSInputTextView alloc] initWithFrame:rect];
        self.previousFrame = frame;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textView = [[DSInputTextView alloc] initWithFrame:CGRectZero];
        self.previousFrame = CGRectZero;
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.previousFrame.size.width != self.bounds.size.width) {
        self.previousFrame = self.frame;
        [self fitToScrollView];
    }
}

//计算大小
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

- (void)setMinNumOfLines:(NSInteger)minNumOfLines {
    if (minNumOfLines <= 0) {
        _minHeight = 0;
        return;
    }
    self.minHeight = [self simulateHeight:minNumOfLines];
    minNumOfLines = minNumOfLines;
}

- (void)setMaxNumOfLines:(NSInteger)maxNumOfLines {
    if (maxNumOfLines <= 0) {
        self.maxHeight = 0;
    }
    self.maxHeight = [self simulateHeight:maxNumOfLines];
    _maxNumOfLines = maxNumOfLines;
}

#pragma mark - Private

- (void)setup {
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;//要加
    self.textView.font = [UIFont systemFontOfSize:FONTSIZE];
    self.textView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textView];
    self.minHeight = self.height;
    self.maxNumOfLines = 3;
    self.showsVerticalScrollIndicator = NO;
}

//行高
- (CGFloat)simulateHeight:(NSInteger)line {
    NSString *saveText = self.textView.text;
    NSMutableString *newText = [NSMutableString stringWithFormat:@"-"];
    
    self.textView.delegate = nil;
    self.textView.hidden = YES;
    //追加字符
    for (NSInteger index = 0; index < line; index++) {
        [newText appendString:@"\n|W|"];
    }
    self.textView.text = newText;
    
    CGFloat textViewMargin = 16;
    //计算后的高度 扣掉 textViewMargin 和 contentInset.top contentInset.bottom
    CGFloat height = [self.textView sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)].height - (textViewMargin + self.textView.contentInset.top + self.textView.contentInset.bottom);
    
    self.textView.text = saveText;
    self.textView.hidden = NO;
    self.textView.delegate = self;
    return height;
    
}

//适应ScrollView
- (void)fitToScrollView {
    //是否在底部了
    BOOL scrollToBottom = self.contentOffset.y == self.contentSize.height - self.height;
    //textView的size
    CGSize actualTextViewSize = [self.textView sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    CGRect oldScrollViewFrame = self.frame;
    
    CGRect frame = self.bounds;
    frame.origin = CGPointZero;
    frame.size.height = actualTextViewSize.height;
    self.textView.frame = frame;
    self.contentSize = frame.size;
    
    CGRect newScrollViewFrame = [self measureFrame:actualTextViewSize];
    
    //将要改变高度
    if (oldScrollViewFrame.size.height != newScrollViewFrame.size.height && newScrollViewFrame.size.height <= self.maxHeight) {
        if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(willChangeHeight:)]) {
            [self.textViewDelegate willChangeHeight:newScrollViewFrame.size.height];
        }
    }
    //改变高度
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

#warning 下次从这里开始

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
//    [self fitToScrollView];
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
//    [self fitToScrollView];
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

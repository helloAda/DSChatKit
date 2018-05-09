//
//  DSInputTextView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/29.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputTextView.h"
#import "UIView+DSCategory.h"

@interface DSInputTextView ()

//是否展示占位文字 没文字的时候显示
@property (nonatomic, assign) BOOL displayPlaceholder;

@end

@implementation DSInputTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        //textView.text改变时 发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// textView.text改变时
- (void)textDidChangeNotification:(NSNotification *)notification {
    [self updatePlaceholder];
}

//设置默认文字 重新绘制
- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText {
    _placeholderAttributedText = placeholderAttributedText;
    [self setNeedsDisplay];
}

//设置文字
- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholder];
}

// 内容为空时,显示默认文字
- (void)updatePlaceholder {
    self.displayPlaceholder = self.text.length == 0;
}

- (void)setDisplayPlaceholder:(BOOL)displayPlaceholder
{
    BOOL old = _displayPlaceholder;
    _displayPlaceholder = displayPlaceholder;
    if (old != self.displayPlaceholder) {
        [self setNeedsDisplay];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //如果不显示默认文字 就不用绘制了
    if (!self.displayPlaceholder) return;
    
    //绘制文字
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = self.textAlignment;
    CGRect targetRect = CGRectMake(5, 8 + self.contentInset.top, self.width - self.contentInset.left, self.height - self.contentInset.top);
    NSAttributedString *attributedString = self.placeholderAttributedText;
    [attributedString drawInRect:targetRect];
}


//长按后显示的UIMenuController的Item
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 复制 粘贴 剪切 选择 选择全部
    if (action == @selector(copy:) || action == @selector(paste:) || action == @selector(cut:) || action == @selector(select:) || action == @selector(selectAll:)) {
        return [super canPerformAction:action withSender:sender];
    }
    return NO;
}
@end

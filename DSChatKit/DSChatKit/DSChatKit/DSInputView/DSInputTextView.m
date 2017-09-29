//
//  DSInputTextView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/29.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputTextView.h"

@interface DSInputTextView ()

//是否展示占位文字
@property (nonatomic, assign) BOOL displayPlaceholder;

@end

@implementation DSInputTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(copy:) || action == @selector(paste:) || action == @selector(cut:) || action == @selector(select:) || action == @selector(selectAll:)) {
        return [super canPerformAction:action withSender:sender];
    }
    return NO;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholder];
}

- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText {
    self.placeholderAttributedText = placeholderAttributedText;
    [self setNeedsDisplay];
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

// textView内容改变时
- (void)textDidChangeNotification:(NSNotification *)notification {
    [self updatePlaceholder];
}

// 内容为空时 显示默认文字
- (void)updatePlaceholder {
    self.displayPlaceholder = self.text.length == 0;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.displayPlaceholder) return;
    
    //段落样式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = self.textAlignment;
    CGRect targetRect = CGRectMake(5, 8 + self.contentInset.top, self.frame.size.width - self.contentInset.left, self.frame.size.height - self.contentInset.top);
    NSAttributedString *attributedString = self.placeholderAttributedText;
    [attributedString drawInRect:targetRect];
}
@end

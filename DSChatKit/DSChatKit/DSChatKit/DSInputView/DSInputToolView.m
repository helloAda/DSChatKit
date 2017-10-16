//
//  DSInputToolView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputToolView.h"
#import "DSInputScrollTextView.h"

#import "UIView+DSCategory.h"

#define BtnPadding 6 //按钮间隔
#define TextViewPadding 3 //文本框间隔



@interface DSInputToolView ()<DSInputScrollTextViewDelegate>

@property (nonatomic, copy)  NSArray<NSNumber *> *types;

@property (nonatomic, strong) DSInputScrollTextView *inputTextView;

@property (nonatomic, assign) DSInputToolStatus status;

@property (nonatomic,copy)  NSDictionary *dict;

@end

@implementation DSInputToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

// 初始化视图
- (void)setupUI {
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [_voiceBtn setImage:[UIImage imageNamed:@"input_voice_normal"] forState:UIControlStateNormal];
    [_voiceBtn setImage:[UIImage imageNamed:@"input_voice_highlight"] forState:UIControlStateHighlighted];
    [_voiceBtn sizeToFit];
    
    _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emojiBtn setImage:[UIImage imageNamed:@"input_emoji_normal"] forState:UIControlStateNormal];
    [_emojiBtn setImage:[UIImage imageNamed:@"input_emoji_highlight"] forState:UIControlStateHighlighted];
    [_emojiBtn sizeToFit];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"input_more_normal"] forState:UIControlStateNormal];
    [_moreBtn setImage:[UIImage imageNamed:@"input_more_highlight"] forState:UIControlStateHighlighted];
    [_moreBtn sizeToFit];
    
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recordBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [_recordBtn setBackgroundImage:[[UIImage imageNamed:@"input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    _recordBtn.exclusiveTouch = YES;
    [_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    _recordBtn.hidden = YES;
    [_recordBtn sizeToFit];
    
    
    _inputTextBackImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_inputTextBackImage setImage:[[UIImage imageNamed:@"input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch]];
    //文本输入框
    _inputTextView = [[DSInputScrollTextView alloc] initWithFrame:CGRectZero];
    _inputTextView.maxNumOfLines = 4;
    _inputTextView.minNumOfLines = 1;
    _inputTextView.textColor = [UIColor blackColor];
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.size = [_inputTextView intrinsicContentSize];
    _inputTextView.textViewDelegate = self;
    _inputTextView.returnKeyType = UIReturnKeySend;
    
    self.types = @[
                   @(DSInputToolViewItemTypeVoice),
                   @(DSInputToolViewItemTypeText),
                   @(DSInputToolViewItemTypeEmoji),
                   @(DSInputToolViewItemTypeMore),
                   ];
}

- (NSString *)contentText {
    return self.inputTextView.text;
}

- (void)setContentText:(NSString *)contentText {
    self.inputTextView.text = contentText;
}

- (NSArray *)inputToolViewItemTypes {
    return self.types;
}

- (void)setInputToolViewItemTypes:(NSArray *)inputToolViewItemTypes {
    self.types = inputToolViewItemTypes;
    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat viewHeight = 0.0f;
    if (self.status == DSInputToolStatusAudio) {
        viewHeight = 54.5;
    }else {
        // 计算 inputTextView宽度
        [self adjustTextViewWidth:size.width];
        //inputTextView高度
        [self.inputTextView layoutIfNeeded];
        viewHeight = self.inputTextView.height;
        //ToolView 高度
        viewHeight = viewHeight + 2 * (BtnPadding + TextViewPadding);
    }
    return CGSizeMake(self.width, viewHeight);
}

//计算inputTextView宽度
- (void)adjustTextViewWidth:(CGFloat)width {
    CGFloat textViewWidth = 0;
    for (NSNumber *type in self.types) {
        if (type.integerValue == DSInputToolViewItemTypeText) {
            continue;
        }
        //获取按钮 计算宽度
        UIView *view = [self subViewForType:type.integerValue];
        textViewWidth += view.width;
    }
    textViewWidth += (BtnPadding * (self.types.count + 1));
    self.inputTextView.width = width - textViewWidth - 2 * TextViewPadding;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.types containsObject:@(DSInputToolViewItemTypeText)]) {
        self.inputTextBackImage.width = self.inputTextView.width + 2 * TextViewPadding;
        self.inputTextBackImage.height = self.inputTextView.height + 2 * TextViewPadding;
    }
    
    CGFloat left = 0;
    //排版
    for (NSNumber *type in self.types) {
        UIView *view = [self subViewForType:type.integerValue];
        if (!view.superview) {
            [self addSubview:view];
        }
        
        view.left = left + BtnPadding;
        view.centerY = self.height * .5f;
        left = view.right;
    }
    
    [self adjustTextAndRecordView];

}

// 计算inputTextView 和 recordBtn frame
- (void)adjustTextAndRecordView {
    
    if ([self.types containsObject:@(DSInputToolViewItemTypeText)]) {
        self.inputTextView.center = self.inputTextBackImage.center;
        
        if (!self.inputTextView.superview) {
            [self addSubview:self.inputTextView];
        }
        if (!self.recordBtn.superview) {
            self.recordBtn.frame = self.inputTextBackImage.frame;
            [self addSubview:self.recordBtn];
        }
    }
}

- (BOOL)showsKeyboard {
    return [self.inputTextView isFirstResponder];
}

- (void)setShowsKeyboard:(BOOL)showsKeyboard {
    if (showsKeyboard) {
        [self.inputTextView becomeFirstResponder];
    }else {
        [self.inputTextView resignFirstResponder];
    }
}

- (void)update:(DSInputToolStatus)status {
    self.status = status;
    [self sizeToFit];
    //文本或更多 状态
    if (status == DSInputToolStatusText || status == DSInputToolStatusMore) {
        self.recordBtn.hidden = YES;
        self.inputTextView.hidden = NO;
        self.inputTextBackImage.hidden = NO;
        [self updateVoiceBtnImage:YES];
        [self updateEmojiBtnImage:YES];
    }
    //声音 状态
    else if (status == DSInputToolStatusAudio) {
        self.recordBtn.hidden = NO;
        self.inputTextView.hidden = YES;
        self.inputTextBackImage.hidden = YES;
        [self updateVoiceBtnImage:NO];
        [self updateEmojiBtnImage:YES];
    }
    //表情 状态
    else {
        self.recordBtn.hidden = YES;
        self.inputTextView.hidden = NO;
        self.inputTextBackImage.hidden = NO;
        [self updateVoiceBtnImage:YES];
        [self updateEmojiBtnImage:NO];
    }
}


//更新声音按钮图片
- (void)updateVoiceBtnImage:(BOOL)selected {
    [self.voiceBtn setImage:selected ? [UIImage imageNamed:@"input_voice_normal"] : [UIImage imageNamed:@"icon_toolview_keyboard_normal"] forState:UIControlStateNormal];
        [self.voiceBtn setImage:selected ? [UIImage imageNamed:@"input_voice_highlight"] : [UIImage imageNamed:@"icon_toolview_keyboard_highlight"] forState:UIControlStateHighlighted];
}

//更新表情按钮图片
- (void)updateEmojiBtnImage:(BOOL)selected {
    [self.emojiBtn setImage:selected ? [UIImage imageNamed:@"input_emoji_normal"] : [UIImage imageNamed:@"icon_toolview_keyboard_normal"] forState:UIControlStateNormal];
    [self.emojiBtn setImage:selected ? [UIImage imageNamed:@"input_emoji_highlight"] : [UIImage imageNamed:@"icon_toolview_keyboard_highlight"] forState:UIControlStateHighlighted];
}



#pragma mark ----  DSInputToolViewDelegate

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText {
    BOOL should = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        should = [self.delegate shouldChangeTextInRange:range replacementText:replacementText];
    }
    return should;
}

- (BOOL)textViewShouldBeginEditing:(DSInputScrollTextView *)scrollTextView {
    BOOL should = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        should = [self.delegate textViewShouldBeginEditing];
    }
    return should;
}

- (void)textViewDidEndEditing:(DSInputScrollTextView *)scrollTextView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidEndEditing)]) {
        [self.delegate textViewDidEndEditing];
    }
}

- (void)textViewDidChange:(DSInputScrollTextView *)scrollTextView {
    if ([self.delegate respondsToSelector:@selector(textViewDidChange)]) {
        [self.delegate textViewDidChange];
    }
}

- (void)willChangeHeight:(CGFloat)height {
    CGFloat toolViewHeight = height + 2 * BtnPadding;
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewWillChangeHeight:)]) {
        [self.delegate toolViewWillChangeHeight:toolViewHeight];
    }
}

- (void)didChangeHeight:(CGFloat)height {
    self.height = height + 2 * (BtnPadding + TextViewPadding);
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewDidChangeHeight:)]) {
        [self.delegate toolViewDidChangeHeight:self.height];
    }
}

#pragma mark ---- get
- (UIView *)subViewForType:(DSInputToolViewItemType)type {
    if (!_dict) {
        _dict = @{
                  @(DSInputToolViewItemTypeVoice) : self.voiceBtn,
                  @(DSInputToolViewItemTypeText)  : self.inputTextBackImage,
                  @(DSInputToolViewItemTypeEmoji) : self.emojiBtn,
                  @(DSInputToolViewItemTypeMore)  : self.moreBtn
                  };
    }
    return _dict[@(type)];
}

@end


@implementation DSInputToolView(inputText)

- (NSRange)selectedRange {
    return self.inputTextView.selectedRange;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    self.inputTextView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
}

- (void)insertText:(NSString *)text {
    NSRange range = self.inputTextView.selectedRange;
    NSString *replaceText = [self.inputTextView.text stringByReplacingCharactersInRange:range withString:text];
    range = NSMakeRange(range.location + text.length, 0);
    self.inputTextView.text = replaceText;
    self.inputTextView.selectedRange = range;
}

- (void)deleteText:(NSRange)range {
    NSString *text = self.contentText;
    if (range.location + range.length <= text.length && range.location != NSNotFound && range.length != 0) {
        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];
        NSRange newRange = NSMakeRange(range.location, 0);
        self.inputTextView.text = newText;
        self.inputTextView.selectedRange = newRange;
    }
}

@end

//
//  DSInputView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputView.h"
#import "DSInputAudioRecordView.h"
#import "UIView+DSCategory.h"

@interface DSInputView ()<DSInputToolViewDelegate,DSInputEmojiViewDelegate>

//语音记录的视图
@property (nonatomic, strong) DSInputAudioRecordView *audioRecordView;
//语音记录的状态
@property (nonatomic, assign) DSInputAudioRecordState recordStatus;
//工具栏的状态
@property (nonatomic, assign) DSInputToolStatus toolStatus;
//默认高度  216
@property (nonatomic, assign) CGFloat defaultcontainerHeight;
//键盘的top值 显示键盘时才有意义
@property (nonatomic, assign) CGFloat keyBoardFrameTop;

//配置信息
@property (nonatomic, weak) id<DSSessionConfig> inputConfig;
//代理
@property (nonatomic, weak) id<DSInputViewDelegate> inputDelegate;
//点击事件代理
@property (nonatomic, weak) id<DSInputActionDelegate> actionDelegate;

@end

@implementation DSInputView



- (instancetype)initWithFrame:(CGRect)frame config:(id<DSSessionConfig>)config
{
    self = [super initWithFrame:frame];
    if (self) {
        _recording = NO;
        _recordStatus = DSInputAudioRecordEnd;
        _inputConfig = config;
        _defaultcontainerHeight = 216;
        _placeholder = @"输入消息";
        self.backgroundColor = [UIColor whiteColor];
        [self addNotification];
    }
    return self;
}

//监听键盘事件
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _emojiView.delegate = nil;
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGFloat toolViewHeight = _toolView.height;
    CGFloat containerHeight = _moreView.height > _emojiView.height ? _moreView.height : _emojiView.height;
    CGFloat height = toolViewHeight + containerHeight;
    height = _defaultcontainerHeight > height ? _defaultcontainerHeight : height;
    CGFloat width = self.superview ? self.superview.width : self.width;
    return CGSizeMake(width, height);
}

#pragma mark --- 外部调用----

//刷新当前键盘状态
- (void)refreshStatus:(DSInputToolStatus)status {
    self.toolStatus = status;
    [self.toolView update:status];
    switch (status) {
        case DSInputToolStatusText:
        case DSInputToolStatusAudio: {
            //键盘显示时
            if (self.toolView.showsKeyboard) {
                self.top = self.keyBoardFrameTop - self.toolView.height;
            }
            //不显示键盘时
            else {
                self.top = self.superview.height - self.toolView.height;
            }
        }
            break;
        case DSInputToolStatusEmoji:
        case DSInputToolStatusMore: {
            self.bottom = self.superview.height;
            break;
        }
        default:
            
            break;
    }
}

- (void)reset {
    self.width = self.superview.width;
    [self sizeToFit];
    [self refreshStatus:DSInputToolStatusText];
    [self didChangeHeight];
}

#pragma mark ---- UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (!self.window) return; //不是堆栈的top
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.keyBoardFrameTop = self.superview.height - endFrame.size.height;
    [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame {
    //隐藏键盘
    if (_keyBoardFrameTop == [UIScreen mainScreen].bounds.size.height) {
        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(hideInputView)]) {
            [self.inputDelegate hideInputView];
        }
    } else {
        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(showInputView)]) {
            [self.inputDelegate showInputView];
        }
    }
    [self sizeToFit];
    [self refreshStatus:self.toolStatus];
    [self didChangeHeight];
}

//改变高度
- (void)didChangeHeight {
    if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(inputViewSizeToHeight:showInputView:)]) {
        CGFloat bottomPadding = self.superview.height - self.top;
        CGPoint point = [self convertPoint:CGPointMake(0, self.toolView.bottom) toView:self.superview];
        BOOL showInputView = point.y != self.superview.height;
        [self.inputDelegate inputViewSizeToHeight:bottomPadding showInputView:showInputView];
    }
}




#pragma mark -- set

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}
- (void)setInputDelegate:(id<DSInputViewDelegate>)delegate {
    _inputDelegate = delegate;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (self.toolView) {
        [self.toolView setPlaceHolder:_placeholder];
    }
}

- (void)setActionDelegate:(id<DSInputActionDelegate>)actionDelegate {
    self.actionDelegate = actionDelegate;
    self.moreView.actionDelegate = self.actionDelegate;
}

#pragma mark -- get

- (DSInputAudioRecordView *)audioRecordView {
    if (!_audioRecordView) {
        _audioRecordView = [[DSInputAudioRecordView alloc] init];
    }
    return _audioRecordView;
}

- (DSInputToolView *)toolView {
    if (!_toolView) {
        _toolView = [[DSInputToolView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        [self addSubview:_toolView];
        [_toolView setPlaceHolder:_placeholder];
        //toolView需要显示的按钮
        if (self.inputConfig && [self.inputConfig respondsToSelector:@selector(inputToolViewItemTypes)]) {
            [_toolView setInputToolViewItemTypes:[self.inputConfig inputToolViewItemTypes]];
        }
        _toolView.delegate = self;
        _toolView.size = [_toolView sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        _toolView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.maxTextLength = 1000;
        [self refreshStatus:DSInputToolStatusText];
        [self sizeToFit];
        [self didChangeHeight];
    }
    return _toolView;
}

- (DSInputMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[DSInputMoreView alloc] initWithFrame:CGRectMake(0, 0, self.width, _defaultcontainerHeight)];
        _moreView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _moreView.hidden = YES;
        _moreView.config = _inputConfig;
        _moreView.actionDelegate = self.actionDelegate;
        [self addSubview:_moreView];
    }
    return _moreView;
}

- (DSInputEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[DSInputEmojiView alloc] initWithFrame:CGRectMake(0, 0, self.width, _defaultcontainerHeight)];
        _emojiView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _emojiView.delegate = self;
        _emojiView.hidden = YES;
        _emojiView.config = _inputConfig;
        [self addSubview:_emojiView];
    }
    return _emojiView;
}
@end

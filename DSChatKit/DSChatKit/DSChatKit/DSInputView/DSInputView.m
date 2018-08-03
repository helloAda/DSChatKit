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
#import <AVFoundation/AVFoundation.h>
#import "DSInputEmojiManager.h"


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
        _atCache = [[DSInputAtCache alloc] init];
        _inputConfig = config;
        _defaultcontainerHeight = 216;
        _placeholder = @"输入消息";
        self.backgroundColor = [UIColor whiteColor];
        [self addNotification];
    }
    return self;
}

//这个方法会在layoutSubviews之前调用
- (void)didMoveToWindow {
    [self toolView];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    _moreView.top = self.toolView.bottom;
    _emojiView.top = self.toolView.bottom;
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

- (void)updateAudioRecordTime:(NSTimeInterval)time {
    self.audioRecordView.recordTime = time;
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


#pragma mark --- button actions
//声音按钮
- (void)onTapVoiceBtn:(UIButton *)btn {
    if (self.toolStatus != DSInputToolStatusAudio) {
        
        __weak typeof(self) weakSelf = self;
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.toolView.showsKeyboard) {
                            weakSelf.toolStatus = DSInputToolStatusAudio;
                            weakSelf.toolView.showsKeyboard = NO;
                        }else{
                            [weakSelf refreshStatus:DSInputToolStatusAudio];
                            [weakSelf didChangeHeight];
                        }
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"没有麦克风权限"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    } else {
        if ([self.toolView.inputToolViewItemTypes containsObject:@(DSInputToolViewItemTypeVoice)]) {
            self.toolStatus = DSInputToolStatusText;
            self.toolView.showsKeyboard = YES;
        }
    }
}

//表情按钮
- (void)onTapEmojiBtn:(UIButton *)btn {
    
    if (self.toolStatus != DSInputToolStatusEmoji) {
        [self bringSubviewToFront:self.emojiView];
        self.emojiView.hidden = NO;
        self.moreView.hidden = YES;
        if (self.toolView.showsKeyboard) {
            self.toolStatus = DSInputToolStatusEmoji;
            self.toolView.showsKeyboard = NO;
        } else {
            [self refreshStatus:DSInputToolStatusEmoji];
            [self didChangeHeight];
        }
    }
    else {
        self.toolStatus = DSInputToolStatusText;
        self.toolView.showsKeyboard = YES;
    }
}

//更多按钮
- (void)onTapMoreBtn:(UIButton *)btn {
    if (self.toolStatus != DSInputToolStatusMore) {
        [self bringSubviewToFront:self.moreView];
        self.emojiView.hidden = YES;
        if (self.toolView.showsKeyboard) {
            self.toolStatus = DSInputToolStatusMore;
            self.toolView.showsKeyboard = NO;
        }
        else {
            [self refreshStatus:DSInputToolStatusMore];
            [self didChangeHeight];
        }
    }
    else {
        self.toolStatus = DSInputToolStatusText;
        self.toolView.showsKeyboard = YES;
    }
}

//  -------------记录声音事件----------------

- (void)onTapRecordBtnDown:(UIButton *)btn {
    self.recordStatus = DSInputAudioRecordStart;
}

- (void)onTapRecordBtnUpInside:(UIButton *)btn {
    // 在按钮内手指离开，录音完成
    self.recordStatus = DSInputAudioRecordEnd;
}

- (void)onTapRecordBtnUpOutside:(UIButton *)btn {
    // 在按钮外手指离开，录音取消
    self.recordStatus = DSInputAudioRecordEnd;
}

- (void)onTapRecordBtnDragInside:(UIButton *)btn {
    // 在按钮内手指还没离开， 提示 "手指上滑，取消发送"
    self.recordStatus = DSInputAudioRecordRecording;
}

- (void)onTapRecordBtnDragOutside:(UIButton *)btn {
    // 在按钮外手指离开，提示 "松开手指，取消发送"
    self.recordStatus = DSInputAudioRecordCancelling;
}


#pragma mark -- DSInputToolViewDelegate

//开始编辑
- (BOOL)textViewShouldBeginEditing {
    self.toolStatus = DSInputToolStatusText;
    return YES;
}

//文本将发生改变
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText {
    //回车
    if ([replacementText isEqualToString:@"\n"]) {
        [self didSelectedSend:nil];
        return NO;
    }
    //删除字符
    if ([replacementText isEqualToString:@""] && range.length == 1) {
        return [self deleteText];
    }
    //输入@
    if ([replacementText isEqualToString:DSInputAtStartChar]) {
        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(inputAtshowSelectView)]) {
            [self.inputDelegate inputAtshowSelectView];
        }
    }
    //输入其它字符
    NSString *str = [self.toolView.contentText stringByAppendingString:replacementText];
    if (str.length > self.maxTextLength) {
        return NO;
    }
    return YES;
}

//文本已经发生改变
- (void)textViewDidChange {
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(textChange:)]) {
        [self.actionDelegate textChange:self];
    }
}

- (void)toolViewDidChangeHeight:(CGFloat)height {
    [self sizeToFit];
    [self refreshStatus:self.toolStatus];
    [self didChangeHeight];
}

#pragma mark -- DSInputEmojiViewDelegate

//添加
- (void)didSelectedAdd:(UIButton *)btn {
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(selectAddBtn:)]) {
        [self.actionDelegate selectAddBtn:btn];
    }
}

//发送
- (void)didSelectedSend:(UIButton *)btn {
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(sendText:atUsers:)] && self.toolView.contentText.length > 0) {
        NSString *sendText = self.toolView.contentText;
        [self.actionDelegate sendText:sendText atUsers:[self.atCache allAtUid:sendText]];
        [self.atCache clean];
        self.toolView.contentText = @"";
        [self.toolView layoutSubviews];
    }
}

//选择表情
- (void)selectEmoji:(NSString *)emojiID catalog:(NSString *)catalogID description:(NSString *)description {
    //删除键
    if (!catalogID) {
        [self deleteText];
    }else {
        //如果是表情加入文本框
        if ([catalogID isEqualToString:EmojiCatalog]) {
            [self.toolView insertText:description];
        }else {
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(selectEmoji:catalog:description:)]) {
                [self.actionDelegate selectEmoticon:emojiID catalog:catalogID];
            }
        }
    }
}


#pragma mark -- private

- (BOOL)endEditing:(BOOL)force {
    BOOL endEnditing = [super endEditing:force];
    __weak typeof(self) weakSelf = self;
    if (!self.toolView.showsKeyboard) {
        [UIView animateWithDuration:0.25 delay:0.00 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            [weakSelf refreshStatus:DSInputToolStatusText];
            if (weakSelf.inputDelegate && [weakSelf.inputDelegate respondsToSelector:@selector(inputViewSizeToHeight:showInputView:)]) {
                [self.inputDelegate inputViewSizeToHeight:weakSelf.toolView.height showInputView:NO];
            }
        } completion:nil];
    }
    return endEnditing;
}

//删除字符
- (BOOL)deleteText {
    NSRange range = [self deleteEmojiRange];
    
    if (range.length == 1) {
        //不是表情，再判断@
        DSInputAtItem *item = [self deleteAtRange];
        if (item) {
            range = item.range;
        }
    }
    //不是表情也不是@，自动删除
    if (range.length == 1) return YES;
    //是表情或者@
    [self.toolView deleteText:range];
    return NO;
}

//是否有需要删除@
- (DSInputAtItem *)deleteAtRange {
    NSString *text = self.toolView.contentText;
    NSRange range = [self rangeForPrefix:DSInputAtStartChar suffix:DSInputAtEndChar];
    NSRange selectedRange = [self.toolView selectedRange];
    DSInputAtItem *item;
    if (range.length > 1) {
        NSString *name = [text substringWithRange:range];
        NSString *set = [DSInputAtEndChar stringByAppendingString:DSInputAtEndChar];
        //去除字符串两端的特殊符号
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:set]];
        item = [self.atCache item:name];
        range = item ? range : NSMakeRange(selectedRange.location - 1, 1);
    }
    item.range = range;
    return item;
}

//是否有需要删除表情
- (NSRange)deleteEmojiRange {
    NSString *text = self.toolView.contentText;
    NSRange range = [self rangeForPrefix:@"[" suffix:@"]"];
    NSRange selectedRange = [self.toolView selectedRange];
    //有找到前缀
    if (range.length > 1) {
        NSString *name = [text substringWithRange:range];
        //判断前缀中的内容是否是表情
        DSInputEmoji *emoji = [[DSInputEmojiManager manager] emojiByTag:name];
        //是的话，删掉，不是就还是只删一个
        range = emoji ? range : NSMakeRange(selectedRange.location - 1, 1);
    }
    return range;
}


//判断文字中是否包含对应前后缀
- (NSRange)rangeForPrefix:(NSString *)prefix suffix:(NSString *)suffix {
    NSString *text = self.toolView.contentText;
    NSRange range = [self.toolView selectedRange];
    NSString *selectedText = range.length ? [text substringWithRange:range] : text;
    NSInteger endLocation = range.location;
    //如果在最开始就不用在往前匹配了
    if (endLocation <= 0) {
        return NSMakeRange(NSNotFound, 0);
    }
    NSInteger index = -1;
    //判断选择删掉的文字中是否包含有后缀
    if ([selectedText hasSuffix:suffix]) {
        //往前搜20个字符，判断前缀
        NSInteger p = 20;
        for (NSInteger i = endLocation; i >= endLocation - p && i - 1 >= 0; i--) {
            NSRange subRange = NSMakeRange(i - 1, 1);
            NSString *subString = [text substringWithRange:subRange];
            if ([subString compare:prefix] == NSOrderedSame) {
                index = i - 1;
                break;
            }
        }
    }
    //如果匹配到前缀，则删除该后缀到前缀中的所有内容 例如[xxxx] 否则只删除一个字符
    return index == -1 ? NSMakeRange(endLocation - 1, 1) : NSMakeRange(index, endLocation - index);
}

#pragma mark -- set

//当前录音状态
- (void)setRecordStatus:(DSInputAudioRecordState)recordStatus {
    //上一次状态
    DSInputAudioRecordState lastStatus = _recordStatus;
    _recordStatus = recordStatus;
    self.audioRecordView.status = _recordStatus;
    if (lastStatus == DSInputAudioRecordEnd) {
        if (_recordStatus == DSInputAudioRecordStart) {
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(startRecording)]) {
                [self.actionDelegate startRecording];
            }
        }
    }
    else if (lastStatus == DSInputAudioRecordStart || lastStatus == DSInputAudioRecordRecording) {
        if (_recordStatus == DSInputAudioRecordEnd) {
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(stopRecording)]) {
                [self.actionDelegate stopRecording];
            }
        }
    }
    else if (lastStatus == DSInputAudioRecordCancel) {
        if (_recordStatus == DSInputAudioRecordEnd) {
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(cancelRecording)]) {
                [self.actionDelegate cancelRecording];
            }
        }
    }
}

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
    _actionDelegate = actionDelegate;
    self.moreView.actionDelegate = self.actionDelegate;
}

- (void)setRecording:(BOOL)recording {
    if (recording) {
        self.audioRecordView.center = self.superview.center;
        [self.superview addSubview:self.audioRecordView];
        self.recordStatus = DSInputAudioRecordRecording;
    } else {
        [self.audioRecordView removeFromSuperview];
        self.recordStatus = DSInputAudioRecordEnd;
    }
    _recording = recording;
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
        [_toolView.voiceBtn addTarget:self action:@selector(onTapVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView.emojiBtn addTarget:self action:@selector(onTapEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView.moreBtn addTarget:self action:@selector(onTapMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView.recordBtn addTarget:self action:@selector(onTapRecordBtnDown:) forControlEvents:UIControlEventTouchDown];
        [_toolView.recordBtn addTarget:self action:@selector(onTapRecordBtnDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [_toolView.recordBtn addTarget:self action:@selector(onTapRecordBtnDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [_toolView.recordBtn addTarget:self action:@selector(onTapRecordBtnUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView.recordBtn addTarget:self action:@selector(onTapRecordBtnUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        _toolView.size = [_toolView sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        _toolView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        if (self.inputConfig.maxTextLength <= 0) {
            self.maxTextLength = 1000;
        }else {
            self.maxTextLength = self.inputConfig.maxTextLength;
        }
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



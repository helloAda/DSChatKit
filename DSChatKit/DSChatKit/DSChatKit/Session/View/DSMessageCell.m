//
//  DSMessageCell.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/16.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSMessageCell.h"
#import "DSBadgeView.h"
#import "DSAvatarImageView.h"
#import "DSCellLayoutConfig.h"
#import "DSChatKit.h"
#import "DSSessionMessageContentView.h"
#import "DSChatKitUIConfig.h"
#import "DSChatKitUtil.h"
#import "UIView+DSCategory.h"

@interface DSMessageCell ()<DSMessageContentViewDelegate>
{
    UILongPressGestureRecognizer *_longPressGesture;
}

@property (nonatomic,strong) DSMessageModel *model;

@property (nonatomic,copy)   NSArray *customViews;
@end

@implementation DSMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    [self removeGestureRecognizer:_longPressGesture];
}

- (void)setupUI {
    
    //重发
    _retrybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retrybutton setImage:[UIImage imageNamed:@"icon_message_cell_error"] forState:UIControlStateNormal];
    [_retrybutton setImage:[UIImage imageNamed:@"icon_message_cell_error"] forState:UIControlStateHighlighted];
    _retrybutton.frame = CGRectMake(0, 0, 20, 20);
    [_retrybutton addTarget:self action:@selector(retryMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_retrybutton];
    //声音未读红点
    _audioPlayedTag = [DSBadgeView viewWithBadgeTip:@""];
    [self.contentView addSubview:_audioPlayedTag];
    
    //发送指示
    _sendActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.contentView addSubview:_sendActivityIndicator];
    
    //头像
    _avatarImageView = [[DSAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_avatarImageView addTarget:self action:@selector(tapAvatar:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAvatar:)];
    [_avatarImageView addGestureRecognizer:gesture];
    [self.contentView addSubview:_avatarImageView];
    
    //昵称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.opaque = YES;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.hidden = YES;
    [self.contentView addSubview:_nameLabel];
    
    //已读标记
    _readLabel = [[UILabel alloc] init];
    _readLabel.backgroundColor = [UIColor clearColor];
    _readLabel.opaque = YES;
    _readLabel.font = [UIFont systemFontOfSize:13.0];
    _readLabel.textColor = [UIColor darkGrayColor];
    _readLabel.bounds = CGRectMake(0, 0, 28, 20);
    [self.contentView addSubview:_readLabel];
    
    //长按手势
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)];
    [self addGestureRecognizer:_longPressGesture];
    
}

#pragma mark --- 刷新数据

- (void)refreshData:(DSMessageModel *)data {
    self.model = data;
    if ([self.model isKindOfClass:[DSMessageModel class]]) {
        [self refresh];
    }
}

- (void)refresh {
    [self addContentViewIfNotExist];
    [self addUserCustomViews];
    
    self.backgroundColor = [DSChatKitUIConfig sharedConfig].globalConfig.backgroundColor;
    
    if (self.model.shouldShowAvatar) {
        //设置头像
        [_avatarImageView setAvatarByMessage:self.model.message];
    }
    if (self.model.shouldShowNickName) {
        //设置用户昵称
        NSString *nick = [DSChatKitUtil showNick:self.model.message.from inMessage:self.model.message];
        self.nameLabel.text = nick;
    }
    //需要显示 就不隐藏
    _nameLabel.hidden = !self.model.shouldShowNickName;
    
    //设置气泡
    [_bubbleView refresh:self.model];
    [_bubbleView setNeedsLayout];
    
    //是否显示加载圈圈
    BOOL isActivityIndicatorHidden = [self activityIndicatorHidden];
    if (isActivityIndicatorHidden) {
        [_sendActivityIndicator stopAnimating];
    }else {
        [_sendActivityIndicator startAnimating];
    }
    _sendActivityIndicator.hidden = isActivityIndicatorHidden;
    //是否显示重试按钮
    _retrybutton.hidden = [self retryButtonHidden];
    //是否语音未读标记要显示
    _audioPlayedTag.hidden = [self audioUnReadHidden];
    //是否显示已读标记
    _readLabel.hidden = [self readLabelHidden];
    
    [self setNeedsLayout];
}


- (void)addContentViewIfNotExist {
    
    if (!_bubbleView) {
        id<DSCellLayoutConfig> layoutConfig = [[DSChatKit shareKit] layoutConfig];
        NSString *contentStr = [layoutConfig cellContent:self.model];
        Class aClass = NSClassFromString(contentStr);
        //聊天气泡
        DSSessionMessageContentView *contentView = [[aClass alloc] initSessionMessageContentView];
        NSAssert(contentView, @"DSMessageCell.m,not init content view");
        _bubbleView = contentView;
        _bubbleView.delegate = self;
//        DSMessageType messageType = self.model.message.messageType;
        //如果后续有代理需要设置 要在这里判断
        [self.contentView addSubview:_bubbleView];
    }
}

- (void)addUserCustomViews {
    for (UIView *view in self.customViews) {
        [view removeFromSuperview];
    }
    id<DSCellLayoutConfig> layoutConfig = [[DSChatKit shareKit] layoutConfig];
    //添加到cell上的用户自定义视图
    self.customViews = [layoutConfig costomViews:self.model];
    
    for (UIView *view in self.customViews) {
        [self.contentView addSubview:view];
    }
}

#pragma mark --- layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutAvatar];
    [self layoutNameLabel];
    [self layoutBubbleView];
    [self layoutRetryButton];
    [self layoutAudioPlayedIcon];
    [self layoutActivityIndicator];
    [self layoutReadLable];
}

//头像布局
- (void)layoutAvatar {
    BOOL needShow = self.model.shouldShowAvatar;
    _avatarImageView.hidden = !needShow;
    if (needShow) {
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat imageWidth = 42;
        //头像显示在右边的时候
        CGFloat originXShowRight = cellWidth - self.model.avatarMargin - imageWidth;
        CGRect avatarRect = self.model.shouldShowLeft ? CGRectMake(self.model.avatarMargin, 0, imageWidth, imageWidth) : CGRectMake(originXShowRight, 0, imageWidth, imageWidth);
        _avatarImageView.frame = avatarRect;
    }
}

//昵称布局
- (void)layoutNameLabel {
    if (self.model.shouldShowNickName) {
        CGFloat bubbleOriginX = self.model.nickNameMargin;
        CGFloat bubbleOriginY = -3.f;
        CGFloat nickNameWidth = 200.f;
        CGFloat nickNameHeight = 20.f;
//        //在右边时 x坐标
//        CGFloat myBubbleOriginX = self.width - self.model.avatarMargin - self.avatarImageView.width - bubbleOriginX;
        //只有在群聊时，他人发过来的消息才显示昵称
        if (self.model.shouldShowLeft) {
            _nameLabel.frame = CGRectMake(bubbleOriginX, bubbleOriginY, nickNameWidth, nickNameHeight);
        }
    }
}

//气泡布局
- (void)layoutBubbleView {
    
    CGSize size = [self.model contentSize:self.width];
    //内容距离气泡间距
    UIEdgeInsets insets = self.model.contentViewInsets;
    //气泡宽 = 内容宽 + 左右间距
    size.width = size.width + insets.left + insets.right;
    size.height = size.height + insets.top + insets.bottom;
    _bubbleView.size = size;
    //气泡距离 cell间距
    UIEdgeInsets contentInsets = self.model.bubbleViewInsets;
    if (!self.model.shouldShowLeft) {
        //消息显示在右边
        CGFloat right = self.model.shouldShowAvatar ? CGRectGetMinX(self.avatarImageView.frame) - 5.f : self.width;
        contentInsets.left = right - CGRectGetWidth(self.bubbleView.bounds);
    }
    _bubbleView.left = contentInsets.left;
    _bubbleView.top = contentInsets.top;
}

//加载圈布局
- (void)layoutActivityIndicator {
    if (_sendActivityIndicator.isAnimating) {
        CGFloat centerX = 0;
        //头像在右边
        if (!self.model.shouldShowLeft) {
            //重试按钮的间隔和加载圈的间隔是一样的就直接用了
            centerX = CGRectGetMinX(_bubbleView.frame) - [self retryButtonBubblePadding] - CGRectGetWidth(_sendActivityIndicator.bounds) / 2;
        }else {
            centerX = CGRectGetMaxX(_bubbleView.frame) + [self retryButtonBubblePadding] + CGRectGetWidth(_sendActivityIndicator.bounds) / 2;
        }
        self.sendActivityIndicator.center = CGPointMake(centerX, _bubbleView.centerY);
    }
}

//重发按钮布局
- (void)layoutRetryButton {
    //没隐藏的话
    if (!_readLabel.isHidden) {
        CGFloat centerX = 0;
        if (self.model.shouldShowLeft) {
            centerX = CGRectGetMaxX(_bubbleView.frame) + [self retryButtonBubblePadding] + CGRectGetWidth(_retrybutton.bounds) / 2;
        } else {
            centerX = CGRectGetMinX(_bubbleView.frame) - [self retryButtonBubblePadding] - CGRectGetWidth(_retrybutton.bounds) / 2;
        }
        _retrybutton.center = CGPointMake(centerX, _bubbleView.center.y);
    }
}

//语音未读标记布局
- (void)layoutAudioPlayedIcon {
    if (!_audioPlayedTag.hidden) {
        CGFloat padding = 10;
        if (self.model.shouldShowLeft) {
            _audioPlayedTag.left = _bubbleView.right + padding;
        }
        else {
            _audioPlayedTag.right = _bubbleView.left - padding;
        }
        _audioPlayedTag.top = _bubbleView.top;
    }
}

//已读标记布局
- (void)layoutReadLable {
    if (!_readLabel.isHidden) {
        _readLabel.left = _bubbleView.left - CGRectGetWidth(_readLabel.bounds) - 2;
        _readLabel.bottom = _bubbleView.bottom;
    }
}

#pragma mark - DSMessageContentViewDelegate

- (void)catchEvent:(DSChatKitEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapCell:)]) {
        [self.delegate tapCell:event];
    }
}

#pragma mark --- action

//重发
- (void)retryMessage:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(retryMessage:)]) {
        [self.delegate retryMessage:self.model.message];
    }
}

//长按手势 加在cell上
- (void)longGesturePress:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longPressCell:inView:)]) {
            [self.delegate longPressCell:self.model.message inView:_bubbleView];
        }
    }
}

//单击头像
- (void)tapAvatar:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapAvatar:)]) {
        [self.delegate tapAvatar:self.model.message.from];
    }
}

//长按头像
- (void)longPressAvatar:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressAvatar:)]) {
            [self.delegate longPressAvatar:self.model.message.from];
        }
    }
}

#pragma mark -- Private

//是否显示加载圈圈
- (BOOL)activityIndicatorHidden {
    //不是收到的消息 即自己发送的 判断发送状态
    if (!self.model.message.isReceivedMsg) {
        //发送中返回NO
        return self.model.message.sendState != DSMessageSendStatusSending;
    }
    //是收到的消息，判断是否有附件，附件接收状态
    else {
        //下载中返回NO
        return self.model.message.attachmentDownloadState != DSMessageAttachmentDownloadStateDownloading;
    }
}

//是否显示 重发按钮
- (BOOL)retryButtonHidden {
    //不是收到的消息
    if (!self.model.message.isReceivedMsg) {
        //失败就返回NO
        return self.model.message.sendState != DSMessageSendStatusFailed;
    }
    //是收到的消息
    else {
        //下载失败返回NO
        return self.model.message.attachmentDownloadState != DSMessageAttachmentDownloadStateFailed;
    }
}

//语音是否读取了
- (BOOL)audioUnReadHidden {
    
    if (self.model.message.messageType == DSMessageTypeAudio) {
        BOOL disable = NO;
        //是否禁用未读红点
        if (self.delegate && [self.delegate respondsToSelector:@selector(disableaudioPlayedStatusIcon:)]) {
            disable = [self.delegate disableaudioPlayedStatusIcon:self.model.message];
        }
        //如果没禁用，并且下载完了 不是自己发送的 没被播放过 这样才返回NO 显示。
        return (self.model.message.attachmentDownloadState != DSMessageAttachmentDownloadStateDownloaded || disable || self.model.message.isSendMsg || self.model.message.isPlayed);
    }
    //不是语音消息不显示
    return YES;
}

//已读标记是否显示
- (BOOL)readLabelHidden {
    //语音标记 和加载圈 都隐藏 而且消息被读取了 才显示
    if (self.model.shouldShowReadLabel && [self activityIndicatorHidden] && [self audioUnReadHidden]) {
        return NO;
    }
    return YES;
}

//重发按钮和气泡的间距
- (CGFloat)retryButtonBubblePadding {
    //语音消息特殊处理
    if (self.model.message.messageType == DSMessageTypeAudio) {
        return self.model.shouldShowLeft ? 13 : 15;
    }
    return self.model.shouldShowLeft ? 10 : 8;
}

@end

//
//  DSSessionVideoContentView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionVideoContentView.h"
#import "DSLoadProgressView.h"
#import "DSVideoObjcet.h"
#import "UIView+DSCategory.h"

@interface DSSessionVideoContentView ()

@property (nonatomic, strong) UIImageView *imageView;
//播放按钮
@property (nonatomic, strong) UIButton *playBtn;
//进度圈
@property (nonatomic, strong) DSLoadProgressView *progressView;

@end

@implementation DSSessionVideoContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_imageView];
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"icon_play_normal"] forState:UIControlStateNormal];
        [_playBtn sizeToFit];
        _playBtn.userInteractionEnabled = NO;
        [self addSubview:_playBtn];
        
        _progressView = [[DSLoadProgressView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _progressView.maxProgress = 1.0;
        [self addSubview:_progressView];
        
    }
    return self;
}

- (void)refresh:(DSMessageModel *)data {
    [super refresh:data];
    DSVideoObjcet *videoObject = (DSVideoObjcet *)self.model.message.messageObject;
    UIImage *image = [UIImage imageWithContentsOfFile:videoObject.coverPath];
    self.imageView.image = image;
    //正在发送就显示
    _progressView.hidden = self.model.message.sendState != DSMessageSendStatusSending;
    
    
    if (!_progressView.hidden) {
        if (self.videoUIDelegate && [self.videoUIDelegate respondsToSelector:@selector(videoTransportProgress:)]) {
            [_progressView setProgress:[self.videoUIDelegate videoTransportProgress:self.model.message]];
        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    
    CGSize contentSize = [self.model contentSize:self.superview.width];
    
    CGRect imageViewRect = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    
    self.imageView.frame = imageViewRect;
    _progressView.frame = self.bounds;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.imageView.bounds;
    self.imageView.layer.mask = maskLayer;
    
    self.playBtn.centerX = self.width * .5f;
    self.playBtn.centerY = self.height * .5f;
    
}

- (void)touchUpInside:(id)sender {
    DSChatKitEvent *event = [[DSChatKitEvent alloc] init];
    event.eventName = DSChatKitEventNameTapContent;
    event.messageModel = self.model;
    [self.delegate catchEvent:event];
}


@end

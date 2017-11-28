//
//  DSSessionImageContentView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionImageContentView.h"
#import "DSLoadProgressView.h"
#import "DSImageObject.h"
#import "UIView+DSCategory.h"

@interface DSSessionImageContentView ()

@property (nonatomic, strong) UIImageView *imageView;
//加载
@property (nonatomic, strong) DSLoadProgressView *progressView;

@end

@implementation DSSessionImageContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_imageView];
        //加载提示
        _progressView = [[DSLoadProgressView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _progressView.maxProgress = 1.0f;
        [self addSubview:_progressView];
    }
    return self;
}

- (void)refresh:(DSMessageModel *)data {
    [super refresh:data];
    DSImageObject *imageObjcet = (DSImageObject *)self.model.message.messageObject;
    UIImage *image = [UIImage imageWithContentsOfFile:imageObjcet.thumbPath];
    
    self.imageView.image = image;
    //是自己发送的信息 在发送的时候不隐藏
    //不是自己发送的 在下载时不隐藏
    self.progressView.hidden = self.model.message.isSendMsg ? (self.model.message.sendState != DSMessageSendStatusSending) : self.model.message.attachmentDownloadState != DSMessageAttachmentDownloadStateDownloading;
    //不隐藏的时候 要有进度
    if (!self.progressView.hidden) {
        if (self.imageUIDelegate && [self.imageUIDelegate respondsToSelector:@selector(imageTransportProgress:)]) {
            [self.progressView setProgress:[self.imageUIDelegate imageTransportProgress:self.model.message]];
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
    
}

//点击
- (void)touchUpInside:(id)sender {
    DSChatKitEvent *event = [[DSChatKitEvent alloc] init];
    event.eventName = DSChatKitEventNameTapContent;
    event.messageModel = self.model;
    [self.delegate catchEvent:event];
}

@end

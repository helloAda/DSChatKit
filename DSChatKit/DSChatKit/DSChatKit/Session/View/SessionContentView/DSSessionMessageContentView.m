//
//  DSSessionMessageContentView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/18.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionMessageContentView.h"
#import "DSChatKitUIConfig.h"
#import "DSMessageModel.h"

@implementation DSSessionMessageContentView

- (instancetype)initSessionMessageContentView {
    CGSize defaultBubbleSize = CGSizeMake(60, 35);
    self = [self initWithFrame:CGRectMake(0, 0, defaultBubbleSize.width, defaultBubbleSize.height)];
    if (self) {
        [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, defaultBubbleSize.width, defaultBubbleSize.height)];
        _bubbleImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bubbleImageView];
    }
    return self;
}

- (void)refresh:(DSMessageModel *)data {
    _model = data;
    //设置气泡图片
    [_bubbleImageView setImage:[self chatBubbleImageForState:UIControlStateNormal outgoing:data.message.isSendMsg]];
    
    [_bubbleImageView setHighlightedImage:[self chatBubbleImageForState:UIControlStateHighlighted outgoing:data.message.isSendMsg]];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bubbleImageView.frame = self.bounds;
}

#pragma mark -- target
- (void)touchDown:(id)sender
{
    
}

- (void)touchUpInside:(id)sender
{
    
}

- (void)touchUpOutside:(id)sender{
    
}

#pragma mark - Private

- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing {
    
    DSChatKitBubbleConfig *config = [[DSChatKitUIConfig sharedConfig] bubbleConfig:self.model.message];
    return [config bubbleImage:state];
    
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    _bubbleImageView.highlighted = highlighted;
}
@end

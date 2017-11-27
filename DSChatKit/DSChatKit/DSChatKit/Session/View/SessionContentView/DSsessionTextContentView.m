//
//  DSsessionTextContentView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSsessionTextContentView.h"
#import "DSChatKitDependency.h"
#import "DSMessageModel.h"
#import "DSChatKitUIConfig.h"
#import "DSInputEmojiParser.h"
#import "UIImage+DSCategory.h"
#import "DSChatKit.h"
#import "UIView+DSCategory.h"

@interface DSsessionTextContentView () <M80AttributedLabelDelegate>

@end
@implementation DSsessionTextContentView


- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        _textLable = [[M80AttributedLabel alloc] init];
        _textLable.delegate = self;
        _textLable.numberOfLines = 0;
        _textLable.lineBreakMode = NSLineBreakByWordWrapping;
        _textLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLable];
    }
    return self;
}

- (void)refresh:(DSMessageModel *)data {
    [super refresh:data];
    
    NSString *text = self.model.message.text;
    
    DSChatKitBubbleConfig *config = [[DSChatKitUIConfig sharedConfig] bubbleConfig:data.message];
    self.textLable.textColor = config.contentTextColor;
    self.textLable.font = config.contentTextFont;
    //设置富文本信息
    [self setText:text];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentSize = [self.model contentSize:self.superview.width];
    CGRect labelFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    self.textLable.frame = labelFrame;
    
}

#pragma mark - M80AttributedLabelDelegate
- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData {
    DSChatKitEvent *event = [[DSChatKitEvent alloc] init];
    event.eventName = DSChatKitEventNameTapLabelLink;
    event.messageModel = self.model;
    event.data = linkData;
    [self.delegate catchEvent:event];
}

#pragma mark -- Private

- (void)setText:(NSString *)text {
    self.textLable.text = @"";
    NSArray *tokens = [[DSInputEmojiParser currentParser] tokens:text];
    
    for (DSInputTextToken *token in tokens) {
        if (token.type == DSInputTokenTypeEmoji) {
            //找到对应的表情信息
            DSInputEmoji *emoji = [[DSInputEmojiManager manager] emojiByTag:token.text];
            UIImage *image = [UIImage ds_fetchBundleImage:emoji.fileName bundleName:[DSChatKit shareKit].emojiBundleName];
            if (image) {
                [self.textLable appendImage:image maxSize:CGSizeMake(18, 18)];
            }
        }
        else {
            NSString *text = token.text;
            [self.textLable appendText:text];
        }
    }
    
}

@end

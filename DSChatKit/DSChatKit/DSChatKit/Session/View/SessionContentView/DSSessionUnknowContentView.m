//
//  DSSessionUnknowContentView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionUnknowContentView.h"
#import "DSChatKitUIConfig.h"
#import "UIView+DSCategory.h"

@interface DSSessionUnknowContentView ()

@property (nonatomic, strong) UILabel *lable;

@end

@implementation DSSessionUnknowContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        _lable = [[UILabel alloc] initWithFrame:CGRectZero];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.userInteractionEnabled = NO;
        [self addSubview:_lable];
    }
    return self;
}

- (void)refresh:(DSMessageModel *)data {
    [super refresh:data];
    NSString *text = @"未知类型消息";
    DSChatKitBubbleConfig *config = [[DSChatKitUIConfig sharedConfig] bubbleConfig:data.message];
    
    self.lable.textColor = config.contentTextColor;
    self.lable.font = config.contentTextFont;
    self.lable.text = text;
    [self.lable sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lable.centerX = self.width * .5f;
    _lable.centerY = self.height * .5f;
}
@end

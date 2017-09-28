//
//  DSInputToolView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputToolView.h"

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
    [_voiceBtn setImage:[UIImage imageName:@"" forState:UIControlStateNormal]];
    _voiceBtn setImage:[UIImage imageName:@"" forState:UIControlStateHighlighted]];
    [_voiceBtn sizeToFit];
    
    _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emojiBtn setImage:[UIImage imageName:@"" forState:UIControlStateNormal]];
    [_emojiBtn setImage:[UIImage imageName:@"" forState:UIControlStateHighlighted]];
    [_emojiBtn sizeToFit];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageName:@"" forState:UIControlStateNormal]];
    [_moreBtn setImage:[UIImage imageName:@"" forState:UIControlStateHighlighted]];
    [_moreBtn sizeToFit];
    
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordBtn setImage:[UIImage imageName:@"" forState:UIControlStateNormal]];
    [_recordBtn setImage:[UIImage imageName:@"" forState:UIControlStateHighlighted]];
    [_recordBtn sizeToFit];
    
    _inputTextBackImage = [[UIImageView alloc] initWithFrame:CGRectZero];
}
@end

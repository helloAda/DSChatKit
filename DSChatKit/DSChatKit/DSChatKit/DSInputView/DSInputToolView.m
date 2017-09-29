//
//  DSInputToolView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputToolView.h"

@interface DSInputToolView ()

@property (nonatomic,copy)  NSArray<NSNumber *> *types;

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
    [_recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recordBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [_recordBtn setBackgroundImage:[[UIImage imageName:@""] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    _recordBtn.exclusiveTouch = YES;
    [_recordBtn sizeToFit];
    
    
    _inputTextBackImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_inputTextBackImage setImage:[[UIImage imageName:@""] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch]];
    

}
@end

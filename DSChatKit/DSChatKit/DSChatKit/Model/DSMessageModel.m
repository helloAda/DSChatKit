//
//  DSMessageModel.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSMessageModel.h"
#import "DSChatKit.h"

@interface DSMessageModel ()
//内容大小信息
@property (nonatomic,strong) NSMutableDictionary *contentSizeInfo;

@end


@implementation DSMessageModel

@synthesize contentViewInsets = _contentViewInsets;
@synthesize bubbleViewInsets  = _bubbleViewInsets;

- (instancetype)initWithMessage:(DSMessage *)message {
    self = [super init];
    if (self) {
        _message = message;
        _messageTime = message.timestamp;
        _contentSizeInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (CGSize)contentSize:(CGFloat)width {
    //先取这个宽度对应的size 如果为CGSizeZero再计算
    CGSize size = [self.contentSizeInfo[@(width)] CGSizeValue];
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        //计算一些cell中需要用到的字段的值
        [self updateLayoutConfig];
        id<DSCellLayoutConfig> layoutConfig = [[DSChatKit shareKit] layoutConfig];
        //放入缓存
        size = [layoutConfig contentSize:self cellWidth:width];
        [self.contentSizeInfo setObject:[NSValue valueWithCGSize:size] forKey:@(width)];
    }
    return size;
}

- (UIEdgeInsets)contentViewInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_contentViewInsets, UIEdgeInsetsZero)) {
        id<DSCellLayoutConfig> layoutConfig = [DSChatKit shareKit].layoutConfig;
        _contentViewInsets = [layoutConfig contentViewInsets:self];
    }
    return _contentViewInsets;
}

- (UIEdgeInsets)bubbleViewInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_bubbleViewInsets, UIEdgeInsetsZero)) {
        id<DSCellLayoutConfig> layoutConfig = [DSChatKit shareKit].layoutConfig;
        _contentViewInsets = [layoutConfig cellInsets:self];
    }
    return _bubbleViewInsets;
}
#pragma mark -- Paivate

- (void)updateLayoutConfig {
    
    id<DSCellLayoutConfig> layoutConfig = [DSChatKit shareKit].layoutConfig;
    
    _shouldShowAvatar   = [layoutConfig shouldShowLeft:self];
    _shouldShowNickName = [layoutConfig shouldShowNickName:self];
    _shouldShowLeft     = [layoutConfig shouldShowLeft:self];
    _avatarMargin       = [layoutConfig avatarMargin:self];
    _nickNameMargin     = [layoutConfig nickNameMargin:self];
    
}
@end

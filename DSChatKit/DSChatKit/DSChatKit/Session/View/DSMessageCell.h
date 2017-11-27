//
//  DSMessageCell.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/16.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSMessageCellDelegate.h"
#import "DSMessageModel.h"

@class DSAvatarImageView;
@class DSSessionMessageContentView;
@class DSBadgeView;

@interface DSMessageCell : UITableViewCell

//头像
@property (nonatomic, strong) DSAvatarImageView *avatarImageView;

//姓名 (群显示 个人不显示)
@property (nonatomic, strong) UILabel *nameLabel;

//内容区域 即气泡包括的区域
@property (nonatomic, strong) DSSessionMessageContentView *bubbleView;

//发送的loading
@property (nonatomic, strong) UIActivityIndicatorView *sendActivityIndicator;

//重试按钮
@property (nonatomic, strong) UIButton *retrybutton;

//语音未读标记
@property (nonatomic, strong) DSBadgeView *audioPlayedTag;

//消息已读标记
@property (nonatomic, strong) UILabel *readLabel;

//代理
@property (nonatomic, weak) id <DSMessageCellDelegate> delegate;

//刷新数据
- (void)refreshData:(DSMessageModel *)data;

@end

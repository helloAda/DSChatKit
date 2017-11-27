//
//  DSSessionMessageContentView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/18.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSChatKitEvent.h"
@protocol DSMessageContentViewDelegate <NSObject>

- (void)catchEvent:(DSChatKitEvent *)event;

@end

@class DSMessageModel;
@interface DSSessionMessageContentView : UIControl



//消息数据
@property (nonatomic, strong, readonly) DSMessageModel *model;
//气泡图片
@property (nonatomic, strong) UIImageView *bubbleImageView;
//代理
@property (nonatomic, weak) id<DSMessageContentViewDelegate> delegate;

//contentView 初始化方法
- (instancetype)initSessionMessageContentView;

//刷新数据
- (void)refresh:(DSMessageModel *)data;

@end

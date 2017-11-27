//
//  DSCellLayoutConfig.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/21.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DSSessionMessageContentView;
@class DSMessageModel;

@protocol DSCellLayoutConfig <NSObject>

// 返回message的内容大小
- (CGSize)contentSize:(DSMessageModel *)model cellWidth:(CGFloat)width;

//需要构造的cellContent类名
- (NSString *)cellContent:(DSMessageModel *)model;

//左对齐的气泡，cell气泡距离整个cell的内间距
- (UIEdgeInsets)cellInsets:(DSMessageModel *)model;

//左对齐的气泡，cell内容距离气泡的内间距
- (UIEdgeInsets)contentViewInsets:(DSMessageModel *)model;

//是否显示头像
- (BOOL)shouldShowAvatar:(DSMessageModel *)model;

//是否显示姓名
- (BOOL)shouldShowNickName:(DSMessageModel *)model;

//左对齐的气泡，头像到左边的距离
- (CGFloat)avatarMargin:(DSMessageModel *)model;

//左对齐的气泡，昵称到左边的距离
- (CGFloat)nickNameMargin:(DSMessageModel *)model;

//消息显示在左边
- (BOOL)shouldShowLeft:(DSMessageModel *)model;

//需要添加到cell上的自定义视图
- (NSArray *)costomViews:(DSMessageModel *)model;

@end

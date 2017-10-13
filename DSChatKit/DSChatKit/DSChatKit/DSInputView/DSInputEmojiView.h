//
//  DSInputEmojiView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPageView.h"
#import "DSInputEmojiBottomView.h"
#import "DSInputEmojiManager.h"
#import "DSSessionConfig.h"

@protocol DSInputEmojiViewDelegate <NSObject>

//点击发送按钮
- (void)didSelectedSend:(UIButton *)btn;
//点击添加按钮
- (void)didSelectedAdd:(UIButton *)btn;
//点击表情
- (void)selectEmoji:(NSString *)emojiID catalog:(NSString *)catalogID description:(NSString *)description;

@end

@interface DSInputEmojiView : UIView
//表情滑动视图
@property (nonatomic, strong) DSPageView *emojiPageView;
//pageControl
@property (nonatomic, strong) UIPageControl *emojiPageControl;
//底部view
@property (nonatomic, strong) DSInputEmojiBottomView *bottomView;
//全部表情数据
@property (nonatomic, strong) NSArray *totalCatalogData;
//当前表情数据
@property (nonatomic, strong) DSInputEmojiCatalog *currentCatalogData;
//配置信息
@property (nonatomic, weak) id<DSSessionConfig> config;
//所有表情 @[DSInputEmoji...]
@property (nonatomic, readonly) NSArray *allEmoji;

@property (nonatomic, weak) id<DSInputEmojiViewDelegate> delegate;
@end

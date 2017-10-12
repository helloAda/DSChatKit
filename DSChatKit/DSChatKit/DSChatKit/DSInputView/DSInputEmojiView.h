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

@interface DSInputEmojiView : UIView
//表情滑动视图
@property (nonatomic, strong) DSPageView *emojiPageView;
//pageControl
@property (nonatomic, strong) UIPageControl *emojiPageControl;
//底部view
@property (nonatomic, strong) DSInputEmojiBottomView *bottomView;
//全部表情数据s
@property (nonatomic, strong) NSArray *totalCatalogData;
//当前表情数据
@property (nonatomic, strong) DSInputEmojiCatalog *currentCatalogData;
//配置信息
@property (nonatomic, weak) id<DSSessionConfig> config;

@end

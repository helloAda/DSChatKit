//
//  DSInputEmojiBottomView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSInputEmojiBottomView;

@protocol DSInputEmojiBottomViewDelegate <NSObject>

//选中表情目录
- (void)bottomView:(DSInputEmojiBottomView *)bottomView didSelectBottomIndex:(NSInteger)index;

@end

@interface DSInputEmojiBottomView : UIControl

//发送按钮
@property (nonatomic, strong) UIButton *sendButton;
//添加按钮
@property (nonatomic, strong) UIButton *addButton;
//目录
@property (nonatomic, strong) UIScrollView *catalogsView;

@property (nonatomic, weak) id<DSInputEmojiBottomViewDelegate> delegate;

//加载表情所有目录
- (void)loadCatalogs:(NSArray *)emojiCatalogs;
//选中对应下标的表情目录
- (void)selectIndex:(NSInteger)index;

@end

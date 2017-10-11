//
//  DSInputEmojiBottomView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSInputEmojiBottomView : UIControl

//发送按钮
@property (nonatomic, strong) UIButton *sendButton;
//添加按钮
@property (nonatomic, strong) UIButton *addButton;
//目录
@property (nonatomic, strong) UIScrollView *catalogsView;

//加载表情目录
- (void)loadCatalogs:(NSArray *)emojiCatalogs

@end

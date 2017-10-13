//
//  DSInputView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSInputToolView.h"
#import "DSInputMoreView.h"
#import "DSInputEmojiView.h"

@interface DSInputView : UIView

//工具栏
@property (nonatomic, strong) DSInputToolView *toolView;
//更多 '+'  视图
@property (nonatomic, strong) DSInputMoreView *moreView;
//表情 '😊' 视图
@property (nonatomic, strong) DSInputEmojiView *emojiView;

@end

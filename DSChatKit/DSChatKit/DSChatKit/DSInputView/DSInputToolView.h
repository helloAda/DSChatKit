//
//  DSInputToolView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DSInputToolStatus) {
    
    DSInputToolStatusText,      // - 文字
    DSInputToolStatusAudio,     // - 声音
    DSInputToolStatusEmoji,     // - 表情
    DSInputToolStatusMore       // - 更多
    
};


@interface DSInputToolView : UIView

//声音按钮
@property (nonatomic, strong) UIButton *voiceBtn;

//表情按钮
@property (nonatomic, strong) UIButton *emojiBtn;

//更多按钮
@property (nonatomic, strong) UIButton *moreBtn;

//记录声音按钮
@property (nonatomic, strong) UIButton *recordBtn;

//输入文字框的背景图片
@property (nonatomic, strong) UIImageView *inputTextBackImage;

//输入的文字
@property (nonatomic, copy) NSString *contentText;


@end

//
//  DSsessionTextContentView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionMessageContentView.h"

@class M80AttributedLabel;
//文本内容
@interface DSsessionTextContentView : DSSessionMessageContentView

//富文本Lable
@property (nonatomic, strong) M80AttributedLabel *textLable;

@end

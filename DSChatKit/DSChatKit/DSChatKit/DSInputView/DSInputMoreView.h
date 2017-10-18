//
//  DSInputMoreView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/6.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSSessionConfig.h"
#import "DSInputActionDelegate.h"

@interface DSInputMoreView : UIView

//配置信息
@property (nonatomic, weak) id<DSSessionConfig> config;
//按钮点击代理
@property (nonatomic, weak) id<DSInputActionDelegate> actionDelegate;

@end

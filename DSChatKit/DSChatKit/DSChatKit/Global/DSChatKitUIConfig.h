//
//  DSChatKitUIConfig.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/21.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DSChatKitBubbleConfig :NSObject

//根据状态返回气泡图片
- (UIImage *)bubbleImage:(UIControlState)state;

@end




@interface DSChatKitGlobalConfig : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;

@end


@class DSMessage;
@interface DSChatKitUIConfig : NSObject

+ (instancetype)sharedConfig;

//气泡配置
- (DSChatKitBubbleConfig *)bubbleConfig:(DSMessage *)message;
//全局配置
- (DSChatKitGlobalConfig *)globalConfig;
@end







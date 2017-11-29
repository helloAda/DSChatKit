//
//  DSSessionVideoContentView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionMessageContentView.h"

@protocol DSVideoContentViewDelegate <NSObject>

@optional
//视频传输进度
- (CGFloat)videoTransportProgress:(DSMessage *)message;

@end

//视频
@interface DSSessionVideoContentView : DSSessionMessageContentView

//代理
@property (nonatomic, weak) id<DSVideoContentViewDelegate> videoUIDelegate;

@end

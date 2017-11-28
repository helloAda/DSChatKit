//
//  DSSessionImageContentView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionMessageContentView.h"

@protocol DSImageContentViewDelegate <NSObject>

@optional

//图片传输的进度
- (CGFloat)imageTransportProgress:(DSMessage *)message;

@end

//图片
@interface DSSessionImageContentView : DSSessionMessageContentView

//代理
@property (nonatomic, weak) id<DSImageContentViewDelegate> imageUIDelegate;

@end

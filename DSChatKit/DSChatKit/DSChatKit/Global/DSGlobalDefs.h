//
//  DSGlobalDefs.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/21.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#ifndef DSGlobalDefs_h
#define DSGlobalDefs_h

#import <Foundation/Foundation.h>

//消息类型枚举
typedef NS_ENUM(NSInteger, DSMessageType) {
    DSMessageTypeText = 0,          //文本
    DSMessageTypeImage = 1,         //图片
    DSMessageTypeAudio = 2,         //声音
    DSMessageTypeVideo = 3,         //视频
    DSMessageTypeLocation = 4,      //位置
    DSMessageTypeNotification = 5,  //通知
    DSMessageTypeFile = 6,          //文件
    DSMessageTypeTip = 7,           //提醒
    DSMessageTypeCustom = 100       //自定义
};

#endif /* DSGlobalDefs_h */

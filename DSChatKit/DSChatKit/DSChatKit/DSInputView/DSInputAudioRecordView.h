//
//  DSInputAudioRecordView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/13.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DSInputAudioRecordState) {
    DSInputAudioRecordStart,           //开始记录语音
    DSInputAudioRecordRecording,       //正在记录语音
    DSInputAudioRecordCancelling,      //取消记录语音
    DSInputAudioRecordEnd              //结束记录语音
};

@interface DSInputAudioRecordView : UIView

//记录状态
@property (nonatomic, assign) DSInputAudioRecordState status;
//记录时间
@property (nonatomic, assign) NSTimeInterval recordTime;

@end

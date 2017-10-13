//
//  DSInputAudioRecordView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/13.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DSInputAudioRecordState) {
    DSInputAudioRecordStart,
    DSInputAudioRecordRecording,
    DSInputAudioRecordCancel,
    DSInputAudioRecordEnd
};

@interface DSInputAudioRecordView : UIView

//记录状态
@property (nonatomic, assign) DSInputAudioRecordState status;
//记录时间
@property (nonatomic, assign) NSTimeInterval recordTime;

@end

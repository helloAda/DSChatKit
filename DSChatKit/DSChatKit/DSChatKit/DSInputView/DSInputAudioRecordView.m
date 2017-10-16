//
//  DSInputAudioRecordView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/13.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputAudioRecordView.h"

const NSInteger audioViewHeight = 160;
const NSInteger audioViewWidth = 110;

const NSInteger timeFontSize = 30;
const NSInteger tipFontSize = 15;


@interface DSInputAudioRecordView () {
    UIImageView *_backgroundView;
    UIImageView *_tipBackgroundView;
}

@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *tipLabel;//提示
@end

@implementation DSInputAudioRecordView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, audioViewWidth, audioViewHeight);
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:_backgroundView];
        
        _tipBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _tipBackgroundView.hidden = YES;
        _tipBackgroundView.frame = CGRectMake(0, audioViewHeight - CGRectGetHeight(_tipBackgroundView.bounds), audioViewWidth, CGRectGetHeight(_tipBackgroundView.bounds));
        [self addSubview:_tipBackgroundView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont boldSystemFontOfSize:timeFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:tipFontSize];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"手指上滑，取消发送";
        [self addSubview:_tipLabel];
        self.status = DSInputAudioRecordEnd;
    }
    return self;
}

- (void)setRecordTime:(NSTimeInterval)recordTime {
    NSInteger minutes = (NSInteger)recordTime / 60;
    NSInteger seconds =(NSInteger)recordTime  % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minutes,seconds];
}

- (void)setStatus:(DSInputAudioRecordState)status {
    if (status == DSInputAudioRecordStart) {
        [self setRecordTime:0];
    } else if (status == DSInputAudioRecordCancel) {
        _tipLabel.text = @"松开手指，取消发送";
        _tipBackgroundView.hidden = NO;
    } else {
        _tipLabel.text = @"手指上滑，取消发送";
        _tipBackgroundView.hidden = YES;
    }
}

- (void)layoutSubviews {
    
    CGSize size = [_timeLabel sizeThatFits:CGSizeMake(audioViewWidth, MAXFLOAT)];
    _timeLabel.frame = CGRectMake(0, 36, audioViewWidth, size.height);
    size = [_tipLabel sizeThatFits:CGSizeMake(audioViewWidth, MAXFLOAT)];
    _tipLabel.frame = CGRectMake(0, audioViewHeight - 10 - size.height, audioViewWidth, size.height);
    
}




@end

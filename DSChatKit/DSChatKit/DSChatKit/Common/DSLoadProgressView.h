//
//  DSLoadProgressView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLoadProgressView : UIView {
    UIImageView *_maskView;
    UILabel *_progressLabel;
    UIActivityIndicatorView *_activity;
}

@property (nonatomic, assign) CGFloat maxProgress;

- (void)setProgress:(CGFloat)progress;

@end

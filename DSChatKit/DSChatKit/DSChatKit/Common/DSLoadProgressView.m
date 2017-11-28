//
//  DSLoadProgressView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSLoadProgressView.h"
#import "UIView+DSCategory.h"

@implementation DSLoadProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maskView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_maskView];
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.font = [UIFont systemFontOfSize:16];
        _progressLabel.textColor = [UIColor whiteColor];
        [self addSubview:_progressLabel];
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_activity];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _maskView.frame = self.bounds;
    CGFloat activityHeight = CGRectGetHeight(_activity.bounds);
    CGSize size = [_progressLabel.text sizeWithAttributes:@{NSFontAttributeName:_progressLabel.font}];
    
    CGFloat totalHeight = activityHeight;
    
    if (size.height) {
        totalHeight += 8 + size.height;
    }
    
    CGFloat y = (CGRectGetHeight(self.bounds) - totalHeight) / 2.0;
    _activity.center = CGPointMake(CGRectGetMidX(self.bounds), y + CGRectGetMidY(_activity.bounds));
    
    _progressLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    _progressLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(_activity.frame) + 8 + size.height / 2);
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(self.left - 4, self.top - 4, self.width + 12, self.height + 8);
    maskLayer.contentsGravity = kCAGravityResize;
    
    _maskView.layer.mask = maskLayer;
    _maskView.layer.masksToBounds = YES;
}

- (void)setProgress:(CGFloat)progress {
    if (progress > self.maxProgress) {
        _progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)self.maxProgress * 100];
        [_activity stopAnimating];
    }else if (progress <= 0) {
        _progressLabel.text = @"0%";
        [_activity startAnimating];
    }else {
        _progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)progress * 100];
    }
    [self setNeedsLayout];
}

@end

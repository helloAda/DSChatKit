//
//  DSBadgeView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/18.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSBadgeView.h"
#import "UIView+DSCategory.h"

@interface DSBadgeView ()
//标记背景颜色
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
//标记字体颜色
@property (nonatomic, strong) UIColor *badgeTextColor;
//标记字体大小
@property (nonatomic, strong) UIFont *badgeTextFont;
//数字顶部到红圈距离
@property (nonatomic, assign) CGFloat badgeTopPadding;
//数字左部到红圈距离
@property (nonatomic, assign) CGFloat badgeLeftPadding;

@end

@implementation DSBadgeView

+ (instancetype)viewWithBadgeTip:(NSString *)badgeValue {
    if (!badgeValue) badgeValue = @"";
    DSBadgeView *instance = [[DSBadgeView alloc] init];
    instance.frame = [instance frameWithStr:badgeValue];
    instance.badgeValue = badgeValue;
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(100, 100, 0, 0)];
    if (self) {
        self.backgroundColor  = [UIColor clearColor];
        _badgeBackgroundColor = [UIColor redColor];
        _badgeTextColor       = [UIColor whiteColor];
        _badgeTextFont        = [UIFont boldSystemFontOfSize:12];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // badge背景色
    CGContextSetFillColorWithColor(context, self.badgeBackgroundColor.CGColor);
    //如果有值
    if (self.badgeValue.length) {
        if ([self badgeValue].integerValue > 9) {
            //圆直径
            CGFloat circleL = self.height;
            //总宽
            CGFloat totalWidth = self.width;
            //中间的矩形宽
            CGFloat rectangularWidth = totalWidth - circleL;
            //左边圆
            CGRect leftCicleFrame = CGRectMake(self.left, self.top, circleL, circleL);
            //矩形
            CGRect rectangularFrame = CGRectMake(self.left + circleL / 2, self.top, rectangularWidth, circleL);
            //右边圆
            CGRect rightCicleFrame = CGRectMake(self.left + rectangularWidth, self.top, circleL, circleL);
            CGContextFillEllipseInRect(context, leftCicleFrame);
            CGContextFillRect(context, rectangularFrame);
            CGContextFillEllipseInRect(context, rightCicleFrame);
        }else{
            CGContextFillEllipseInRect(context, self.bounds);
        }
        
        NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [badgeTextStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *badgeTextAttributes = @{
                                              NSFontAttributeName: [self badgeTextFont],
                                              NSForegroundColorAttributeName: [self badgeTextColor],
                                              NSParagraphStyleAttributeName: badgeTextStyle,
                                              };
        CGRect badgeSize = CGRectInset(self.bounds, self.badgeLeftPadding, self.badgeTopPadding);
        [self.badgeValue drawInRect:CGRectMake (self.badgeLeftPadding,
                                                self.badgeTopPadding,
                                                badgeSize.size.width, badgeSize.size.height)
                     withAttributes:badgeTextAttributes];
    }
    //没有值
    else {
        CGContextFillEllipseInRect(context, self.bounds);
    }
}

#pragma mark --- Private
//计算字体frame
- (CGRect)frameWithStr:(NSString *)badgeValue {
    
    if (!badgeValue || badgeValue.length == 0)
    {
        //没值 只显示红点的时候 宽高多4
        return CGRectMake(self.left, self.top, self.badgeLeftPadding * 2 + 4, self.badgeTopPadding * 2 + 4);
    }
    else
    {
        CGSize badgeSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName:self.badgeTextFont}];
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        CGRect badgeFrame = CGRectMake(self.left, self.top, badgeSize.width + self.badgeLeftPadding * 2, badgeSize.height + self.badgeTopPadding * 2);
        return badgeFrame;
    }
    
}


#pragma mark --- set

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    //两位数以上的时候会横向拉长 间隔要大一点
    if (_badgeValue.integerValue > 9) {
        _badgeLeftPadding = 6.f;
    }else {
        _badgeLeftPadding = 2.f;
    }
    _badgeTopPadding = 2.f;
    
    self.frame = [self frameWithStr:badgeValue];
    [self setNeedsDisplay];
}



@end



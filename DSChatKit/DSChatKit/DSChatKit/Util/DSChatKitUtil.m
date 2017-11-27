//
//  DSChatKitUtil.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/22.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSChatKitUtil.h"
#import "DSChatKit.h"
@implementation DSChatKitUtil

+ (NSString *)showNick:(NSString *)uid inMessage:(DSMessage *)message {
    if (!uid.length) return nil;
    DSChatKitInfoFetchOption *option = [[DSChatKitInfoFetchOption alloc] init];
    option.message = message;
    return [[DSChatKit shareKit] infoByUser:uid option:option].showName;
}

+ (NSString *)showTime:(NSTimeInterval)msglastTime showDetail:(BOOL)showDetail {
    //当前时间
    NSDate *nowDate = [NSDate date];
    //消息时间
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    
    NSCalendarUnit components = (NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    result = [self getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    
    if (hour > 12) {
        hour = hour - 12;
    }
    //同一天的消息
    if (nowDateComponents.day == msgDateComponents.day) {
        result = [NSString stringWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute];
    }
    //昨天
    else if (nowDateComponents.day == (msgDateComponents.day + 1)) {
        result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天";
    }
    //前天
    else if(nowDateComponents.day == (msgDateComponents.day + 2)) //前天
    {
        result = showDetail? [NSString stringWithFormat:@"前天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"前天";
    }
    //一周内
    else if ([nowDate timeIntervalSinceDate:msgDate] < 7 * 24 * 60 * 60) {
        NSString *weekDay = [self weekdayStr:msgDateComponents.weekday];
        result = showDetail ? [weekDay stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : weekDay;
    }
    //一周以上 直接显示日期
    else {
        NSString *day = [NSString stringWithFormat:@"%zd-%zd-%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        result = showDetail? [day stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
    }
    return result;
}

#pragma mark - Private

+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute {
    
    NSInteger totalMin = time * 60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin > 0 && totalMin <= 5 * 60)
    {
        showPeriodOfTime = @"凌晨";
    }
    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
    {
        showPeriodOfTime = @"下午";
    }
    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
    {
        showPeriodOfTime = @"晚上";
    }
    return showPeriodOfTime;
}

+(NSString*)weekdayStr:(NSInteger)dayOfWeek
{
    static NSDictionary *daysOfWeekDict = nil;
    daysOfWeekDict = @{@(1):@"星期日",
                       @(2):@"星期一",
                       @(3):@"星期二",
                       @(4):@"星期三",
                       @(5):@"星期四",
                       @(6):@"星期五",
                       @(7):@"星期六",};
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}

@end

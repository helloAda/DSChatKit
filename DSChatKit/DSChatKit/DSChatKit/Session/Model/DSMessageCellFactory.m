//
//  DSMessageCellFactory.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSMessageCellFactory.h"
#import "DSChatKit.h"
@implementation DSMessageCellFactory

- (DSMessageCell *)cellInTable:(UITableView *)tableView forMessageMode:(DSMessageModel *)model {
    id<DSCellLayoutConfig> layoutConfig = [[DSChatKit shareKit] layoutConfig];
    NSString *identity = [layoutConfig cellContent:model];
    DSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        NSString *classStr = @"DSMessageCell";
        [tableView registerClass:NSClassFromString(classStr) forCellReuseIdentifier:identity];
        cell = [tableView dequeueReusableCellWithIdentifier:identity];
    }
    return (DSMessageCell *)cell;
}

- (DSSessionTimestampCell *)cellInTable:(UITableView *)tableView forTimeMode:(DSTimestampModel *)model {
    NSString *identity = @"time";
    DSSessionTimestampCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        NSString *classStr = @"DSSessionTimestampCell";
        [tableView registerClass:NSClassFromString(classStr) forCellReuseIdentifier:identity];
        cell = [tableView dequeueReusableCellWithIdentifier:identity];
    }
    [cell refreshData:model];
    return (DSSessionTimestampCell *)cell;
}

@end

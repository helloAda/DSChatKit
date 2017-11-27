//
//  DSMessageCellFactory.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DSMessageCell.h"
#import "DSSessionTimestampCell.h"
//cell 工厂
@interface DSMessageCellFactory : NSObject

//消息cell
- (DSMessageCell *)cellInTable:(UITableView *)tableView forMessageMode:(DSMessageModel *)model;

//时间戳cell
- (DSSessionTimestampCell *)cellInTable:(UITableView *)tableView forTimeMode:(DSTimestampModel *)model;

@end

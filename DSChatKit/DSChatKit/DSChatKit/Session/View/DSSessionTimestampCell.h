//
//  DSSessionTimestampCell.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DSTimestampModel.h"

@interface DSSessionTimestampCell : UITableViewCell
//背景
@property (nonatomic, strong) UIImageView *timeBGView;
//时间
@property (nonatomic, strong) UILabel *timeLable;

//刷新数据
- (void)refreshData:(DSTimestampModel *)data;

@end

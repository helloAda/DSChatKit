//
//  DSChatKit.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/12.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

//cell排版配置
#import "DSCellLayoutConfig.h"

#import "DSChatKitInfoFetchOption.h"
#import "DSChatKitInfo.h"

@interface DSChatKit : NSObject


+ (instancetype)shareKit;

- (id<DSCellLayoutConfig>)layoutConfig;

//表情资源所在的bundle名称
@property (nonatomic, copy) NSString *emojiBundleName;


//返回用户信息
- (DSChatKitInfo *)infoByUser:(NSString *)userId option:(DSChatKitInfoFetchOption *)option;

@end

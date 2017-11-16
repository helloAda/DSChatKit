//
//  DSSessionDataSource.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSession.h"
#import "DSSessionConfig.h"
#import "DSSessionPrivateProtocol.h"

//数据源实现
@interface DSSessionDataSource : NSObject<DSSessionDataSourceProtocol>

- (instancetype)initWithSession:(DSSession *)session config:(id<DSSessionConfig>)sessionConfig;

@end

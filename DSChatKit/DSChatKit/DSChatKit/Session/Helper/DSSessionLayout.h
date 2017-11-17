//
//  DSSessionLayout.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSessionPrivateProtocol.h"

@interface DSSessionLayout : NSObject<DSSessionLayoutProtocol>

//初始化
- (instancetype)initWithSession:(DSSession *)session
                      tableView:(UITableView *)tableView
                         config:(id<DSSessionConfig>)sessionConfig;

//代理
@property (nonatomic, weak) id<DSSessionLayoutProtocolDelegate> delegate;

@end

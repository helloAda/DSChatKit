//
//  DSSessionInteractor.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSessionPrivateProtocol.h"
#import "DSSessionConfigurateProtocol.h"

// 用于 数据源(DSSessionDataSource)和排版(DSSessionLayout) 与适配器(DSSessionTableAdapter) 交互
@interface DSSessionInteractor : NSObject<DSSessionInteractorProtocol,DSSessionLayoutProtocolDelegate>


- (instancetype)initWithSession:(DSSession *)session config:(id<DSSessionConfig>)sessionConfig;

@property (nonatomic, weak) id <DSSessionInteractorProtocolDelegate> delegate;

@property (nonatomic, strong) id <DSSessionDataSourceProtocol> dataSource;

@property (nonatomic, strong) id <DSSessionLayoutProtocol> layout;

@end

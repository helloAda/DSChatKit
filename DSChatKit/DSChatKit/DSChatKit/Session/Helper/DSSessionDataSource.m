//
//  DSSessionDataSource.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionDataSource.h"

@interface DSSessionDataSource ()

@property (nonatomic, strong) DSSession *session;

@property (nonatomic, strong) id<DSSessionConfig> sessionConfig;


@end

@implementation DSSessionDataSource

- (instancetype)initWithSession:(DSSession *)session config:(id<DSSessionConfig>)sessionConfig {
    self = [super init];
    if (self) {
        _session = session;
        _sessionConfig = sessionConfig;
    }
    return self;
}
@end

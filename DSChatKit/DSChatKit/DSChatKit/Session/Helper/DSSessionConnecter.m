//
//  DSSessionConnecter.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionConnecter.h"
#import "DSSession.h"
#import "DSSessionConfig.h"
#import "DSSessionDataSource.h"
#import "DSSessionViewController.h"
@interface DSSessionConnecter ()


@end

@implementation DSSessionConnecter

- (void)connect:(DSSessionViewController *)vc {
    DSSession *session = vc.session;
    id <DSSessionConfig> sessionConfig = vc.sessionConfig;
    UITableView *tableView = vc.tableView;
    
    DSSessionDataSource *dataSource = [[DSSessionDataSource alloc] init];
}
@end

//
//  DSSessionConnecter.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionConnecter.h"
#import "DSSessionViewController.h"
#import "DSSessionDataSource.h"
#import "DSSessionLayout.h"
@interface DSSessionConnecter ()


@end

@implementation DSSessionConnecter

- (void)connect:(DSSessionViewController *)vc {
    DSSession *session = vc.session;
    id <DSSessionConfig> sessionConfig = vc.sessionConfig;
    UITableView *tableView = vc.tableView;
    //数据源实现
    DSSessionDataSource *dataSource = [[DSSessionDataSource alloc] init];
    //排版实现
    DSSessionLayout *layout = [[DSSessionLayout alloc] initWithSession:session tableView:tableView config:sessionConfig];
    
}
@end

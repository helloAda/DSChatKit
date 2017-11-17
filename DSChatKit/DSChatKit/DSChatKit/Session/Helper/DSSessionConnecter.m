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
#import "DSSessionInteractor.h"

@interface DSSessionConnecter ()


@end

@implementation DSSessionConnecter

- (void)connect:(DSSessionViewController *)vc {
    DSSession *session = vc.session;
    id <DSSessionConfig> sessionConfig = vc.sessionConfig;
    UITableView *tableView = vc.tableView;
    //数据源实现
    DSSessionDataSource *dataSource = [[DSSessionDataSource alloc] initWithSession:session config:sessionConfig];
    //排版实现
    DSSessionLayout *layout = [[DSSessionLayout alloc] initWithSession:session tableView:tableView config:sessionConfig];
    
    //用于 数据、排版与适配器交互
    DSSessionInteractor *interactor = [[DSSessionInteractor alloc] initWithSession:session config:sessionConfig];
    interactor.delegate = vc;
    interactor.dataSource = dataSource;
    interactor.layout = layout;
    
    [layout setDelegate:interactor];
}
@end

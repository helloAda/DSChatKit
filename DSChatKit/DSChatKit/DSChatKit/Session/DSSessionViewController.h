//
//  DSSessionViewController.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/18.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSSessionConfig.h"
#import "DSSession.h"

@interface DSSessionViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
//会话对象
@property (nonatomic, strong) DSSession *session;


/**
 初始化方法

 @param session 所属会话
 @return 实例
 */
- (instancetype)initWithSession:(DSSession *)session;

// 会话详细配置 继承后需要重写一下
- (id<DSSessionConfig>)sessionConfig;

@end

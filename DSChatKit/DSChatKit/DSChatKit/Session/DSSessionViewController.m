//
//  DSSessionViewController.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/18.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionViewController.h"
#import "DSInputView.h"
#import "DSChatKitMacro.h"
#import "UIView+DSCategory.h"
#import "DSSessionConnecter.h"

@interface DSSessionViewController ()<DSInputViewDelegate,DSInputActionDelegate>

//输入控件
@property (nonatomic, strong) DSInputView *inputView;

////标题，类似于微信的用户名称
//@property (nonatomic, strong) UILabel *titleLable;
////子标题，类似于QQ的手机在线状态 显示在标题下
//@property (nonatomic, strong) UILabel *subTitleLable;

//连接 数据源、排版对象以及tableView的代理   与视图控制器解耦
@property (nonatomic, strong) DSSessionConnecter *connecter;
@end

@implementation DSSessionViewController


- (instancetype)initWithSession:(DSSession *)session {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableView
    [self setupTableView];
    //初始化输入框
    [self setupInputView];
    //会话相关数据源、排版 代理设置
    [self setupConnecter];
}

#pragma mark --  all init

- (void)setupTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = DScolorFromRGBA(0xe4e7ec, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

- (void)setupInputView {
    if ([self isShowInputView]) {
        _inputView = [[DSInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0) config:self.sessionConfig];
        _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_inputView refreshStatus:DSInputToolStatusText];
        [_inputView setInputDelegate:self];
        [_inputView setActionDelegate:self];
        [self.view addSubview:_inputView];
        self.tableView.height -= self.inputView.toolView.height;
    }
}

- (void)setupConnecter {
    _connecter = [[DSSessionConnecter alloc] init];
    [_connecter connect:self];
}


// 是否显示输入框 3D Touch预览的时候不需要。默认需要显示
- (BOOL)isShowInputView {
    if (self.sessionConfig  && [self.sessionConfig respondsToSelector:@selector(isShowInputView)]) {
        return [self.sessionConfig isShowInputView];
    }
    return YES;
}


//使用默认的配置
- (id<DSSessionConfig>)sessionConfig {
    return nil;
}
@end

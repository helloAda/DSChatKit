//
//  DSSessionLayout.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionLayout.h"
#import "UIView+DSCategory.h"
#import "UITableView+DSCategory.h"
#import "DSMessageCell.h"

@interface DSSessionLayout () {
    //键盘高度
    CGFloat _inputViewHeight;
}

@property (nonatomic, strong) UITableView *tableView;
//配置信息
@property (nonatomic, strong) id<DSSessionConfig> sessionConfig;
//当前会话
@property (nonatomic, strong) DSSession *session;
//下拉刷新控件
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic,assign)  CGRect viewRect;

@end

@implementation DSSessionLayout

//这里暂时预留这些， 其实只需要tableView传进来就够了
- (instancetype)initWithSession:(DSSession *)session
                      tableView:(UITableView *)tableView
                         config:(id<DSSessionConfig>)sessionConfig {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _sessionConfig = sessionConfig;
        _session = session;
        //添加下拉刷新
        [self setupRefreshControl];
        //监听菜单隐藏通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTable {
    [self.tableView reloadData];
}

- (void)resetLayout {
    [self adjustTableView];
}


- (void)layoutAfterRefresh {
    
    /**
     刷新之后contentSize.height会改变 所以偏移量也需要改变
     
     刷新之后偏移量 = 刷新之后列表高度 - 没刷新列表之前高度 + 没刷新列表之前偏移量
     */
    [self.refreshControl endRefreshing];
    
    CGFloat offset = self.tableView.contentSize.height - self.tableView.contentOffset.y;
    [self.tableView reloadData];
    CGFloat offsetYAfterLoad = self.tableView.contentSize.height - offset;
    CGPoint point = self.tableView.contentOffset;
    point.y = offsetYAfterLoad;
    [self.tableView setContentOffset:point animated:NO];
    
}

- (void)changeLayout:(CGFloat)inputViewHeight {
    //不相等 就改变
    BOOL change = _inputViewHeight != inputViewHeight;
    if (change) {
        _inputViewHeight = inputViewHeight;
        [self adjustTableView];
    }
}

//调整tableView布局
- (void)adjustTableView {
    //如果viewRect和tableView的superview frame不相等就 刷新界面
    BOOL viewRectChange = !CGRectEqualToRect(_viewRect, self.tableView.superview.frame);
    self.viewRect = self.tableView.superview.frame;
    
    CGRect rect = _tableView.frame;
    rect.origin.y = 0;
    //减去键盘的高度
    rect.size.height = self.viewRect.size.height - _inputViewHeight;
    //如果tableView的高度没有和界面减去键盘高度相等 刷新界面
    BOOL tableChanged = !CGRectEqualToRect(_tableView.frame, rect);
    _tableView.frame = rect;
    
    //是否刷新界面 并且滚动到底部
    if (tableChanged || viewRectChange) {
        [_tableView reloadData];
        [_tableView ds_scrollToBottom:NO];
    }
}

- (void)calculateContent:(DSMessageModel *)model {
    [model contentSize:self.tableView.width];
}

- (void)insert:(NSArray *)indexPaths animated:(BOOL)animated {
    if (!indexPaths.count) return;
    
    NSMutableArray *addIndexPathes = [NSMutableArray array];
    [indexPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:0];
        [addIndexPathes addObject:indexPath];
    }];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:addIndexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView ds_scrollToBottom:animated];
    
}

- (void)remove:(NSArray *)indexPaths {
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)update:(NSIndexPath *)indexPath {
    DSMessageCell *cell =(DSMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        CGFloat scrollOffsetY = self.tableView.contentOffset.y;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, scrollOffsetY) animated:NO];
    }
}


#pragma mark - Notification

//菜单隐藏
- (void)menuDidHide:(NSNotification *)notification {
    [UIMenuController sharedMenuController].menuItems = nil;
}

#pragma mark -- Private

//初始化下拉控件
- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:_refreshControl];
    [self.refreshControl addTarget:self action:@selector(headerRereshing:) forControlEvents:UIControlEventValueChanged];
}
//下拉执行方法
- (void)headerRereshing:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refresh)])
    {
        [self.delegate refresh];
    }
}


@end

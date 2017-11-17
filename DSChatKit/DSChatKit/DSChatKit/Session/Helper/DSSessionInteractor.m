//
//  DSSessionInteractor.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionInteractor.h"

@interface DSSessionInteractor ()

//当前会话
@property (nonatomic, strong) DSSession  *session;
//配置信息
@property (nonatomic, strong) id<DSSessionConfig> sessionConfig;

@end

@implementation DSSessionInteractor

- (instancetype)initWithSession:(DSSession *)session config:(id<DSSessionConfig>)sessionConfig {
    self = [super init];
    if (self) {
        _session = session;
        _sessionConfig = sessionConfig;
        [self addListener];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- DSSessionLayoutProtocolDelegate
//下拉刷新
- (void)refresh {
    __weak typeof(self) wself = self;
    [self loadMessages:^(NSArray *messages, NSError *error) {
        [wself.layout layoutAfterRefresh];
        if ([wself shouldHandleReceipt] && messages.count) {
            [wself checkReceipt];
        }
    }];
}


#pragma mark -- DSSessionInteractorProtocol

#pragma mark --  界面操作  --

- (void)addMessages:(NSArray *)messages {
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (DSMessage *message in messages) {
        //如果是被删除的了 直接跳过
        if (message.isDeleted) continue;
        DSMessageModel *model = [[DSMessageModel alloc] initWithMessage:message];
        [models addObject:model];
    }
    
    DSSessionMessageOperateResult *result = [self.dataSource addMessageModels:models];
    [self.layout insert:result.indexpaths animated:YES];
}

- (void)insertMessages:(NSArray *)messages {
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (DSMessage *message in messages) {
        DSMessageModel *model = [[DSMessageModel alloc] initWithMessage:message];
        [models addObject:model];
    }
    DSSessionMessageOperateResult *result = [self.dataSource insertMessageModels:models];
    [self.layout insert:result.indexpaths animated:YES];
}

- (DSMessageModel *)deleteMessage:(DSMessage *)message {
    DSMessageModel *model = [self findMessageModel:message];
    if (model) {
        DSSessionMessageOperateResult *result = [self.dataSource deleteMessageModel:model];
        [self.layout remove:result.indexpaths];
    }
    return model;
}

- (DSMessageModel *)updateMessage:(DSMessage *)message {
    DSMessageModel *model = [self findMessageModel:message];
    if (model) {
        DSSessionMessageOperateResult *result = [self.dataSource updateMessageModel:model];
        //result.indexpaths里只存了一个
        [self.layout update:result.indexpaths.firstObject];
    }
    return model;
}

#pragma mark     --  数据操作  --

- (NSArray *)items {
    return [self.dataSource items];
}

- (DSMessageModel *)findMessageModel:(DSMessage *)message {
    if ([message isKindOfClass:[DSMessage class]]) {
        return [self.dataSource findModel:message];
    }
    return nil;
}

- (void)checkReceipt {
    NSDictionary *models = [self.dataSource checkReceipt];
    for (NSNumber *index in models.allKeys) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index.integerValue inSection:0];
        [self.layout update:indexPath];
    }
}

- (BOOL)shouldHandleReceipt {
    //只有单聊 并且是配置里所支持的类型才会返回YES
    return self.session.sessionType == DSSessionTypeSingle && [self.sessionConfig respondsToSelector:@selector(shouldHandleReceipt)] && [self.sessionConfig shouldHandleReceipt];
}

- (void)sendMessageReceipt:(NSArray *)messages complete:(void (^)(DSMessage *))complete {
    [self.dataSource sendMessageReceipt:messages complete:^(DSMessage *message) {
        complete(message);
    }];
}

- (void)resetMessage {
    __weak typeof(self) wself = self;
    [self.dataSource resetMessages:^(NSError *error) {
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(didFetchMessageData)]) {
            [wself.delegate didFetchMessageData];
        }
    }];
}

- (void)loadMessages:(void (^)(NSArray *, NSError *))handler {
    __weak typeof(self) wself = self;
    [self.dataSource loadHistoryMessagesWithComplete:^(NSInteger index, NSArray *messages, NSError *error) {
        if (messages.count) {
            [wself.layout layoutAfterRefresh];
            [wself.dataSource checkAttachmentState:messages complete:^(DSMessage *message) {
                //这里的message为附件,并且附件是没有下载的状态 会执行该代理
                if (wself.delegate && [wself.delegate respondsToSelector:@selector(checkAttachmentState:)]) {
                    [wself.delegate checkAttachmentState:message];
                }
            }];
        }
        if (handler) {
            handler(messages,error);
        }
    }];
}

#pragma mark -- 排版操作 --

- (void)resetLayout {
    [self.layout resetLayout];
}

- (void)changeLayout:(CGFloat)inputHeight {
    [self.layout changeLayout:inputHeight];
}

#pragma mark -- 按钮响应接口 --

- (void)onViewWillAppear {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.layout reloadTable];
    });
}
#pragma mark - Notifitcation 通知

//程序从后台激活
- (void)vcBecomeActive:(NSNotification *)notification {
    NSArray *models = self.dataSource.items;
    __weak typeof(self) wself = self;
    /**
     因为这里也需要发送已读回执，但是已读回执不属于该库的内容，需要将它传递出去交给上层开发者
     */
    [self.dataSource sendMessageReceipt:models complete:^(DSMessage *message) {
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(sendMessageReceipt:)]) {
            [wself.delegate sendMessageReceipt:message];
        }
    }];
    
}

//用户信息更新
- (void)userInfoHasUpdatedNotification:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRefreshMessageData)]){
        [self.delegate didRefreshMessageData];
    }
}

//群信息更新
- (void)teamInfoHasUpdatedNotification:(NSNotification *)notification {
    [self teamNotification:notification];
}

//群成员信息更新
- (void)teamMembersHasUpdatedNotification:(NSNotification *)notification {
    [self teamNotification:notification];
}



#pragma mark -- Private

//群事件更新
- (void)teamNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    extern NSString *DSChatKitInfoKey;
    NSArray *teamIds = userInfo[DSChatKitInfoKey];
    //群聊
    if (self.session.sessionType == DSSessionTypeGroup && ([teamIds containsObject:self.session.sessionID] || [teamIds containsObject:[NSNull null]])) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didRefreshMessageData)]) {
            [self.delegate didRefreshMessageData];
        }
    }
}

//添加事件监听
- (void)addListener {
    //声音的监听 在viewWillApear添加
    //程序从后台激活通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    //如果是群聊
    if (self.session.sessionType == DSSessionTypeGroup) {
        extern NSString *const DSChatKitTeamInfoHasUpdatedNotification;
        extern NSString *const DSChatKitTeamMembersHasUpdateNotification;
        //群信息更新
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamInfoHasUpdatedNotification:) name:DSChatKitTeamInfoHasUpdatedNotification object:nil];
        //群成员更新
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamMembersHasUpdatedNotification:) name:DSChatKitTeamMembersHasUpdateNotification object:nil];
    }
    //用户信息更新
    extern NSString *const DSChatKitUserInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoHasUpdatedNotification:) name:DSChatKitUserInfoHasUpdatedNotification object:nil];
    
}

- (void)autoFetchMessages {
    if (![self.sessionConfig respondsToSelector:@selector(autoFetchMessageWhenOpenSession)] || self.sessionConfig.autoFetchMessageWhenOpenSession) {
        __weak typeof(self) wself = self;
        [self.dataSource resetMessages:^(NSError *error) {
            if ([wself.delegate respondsToSelector:@selector(didFetchMessageData)]) {
                [wself.delegate didFetchMessageData];
            }
        }];
    }
}

#pragma mark --- set

- (void)setDataSource:(id<DSSessionDataSourceProtocol>)dataSource {
    _dataSource = dataSource;
    __weak typeof(self) wself = self;
    [self.dataSource checkAttachmentState:self.items complete:^(DSMessage *message) {
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(checkAttachmentState:)]) {
            [wself.delegate checkAttachmentState:message];
        }
    }];
    [self autoFetchMessages];
}
@end

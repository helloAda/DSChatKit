//
//  DSSessionDataSource.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionDataSource.h"
#import "DSSessionMsgDataSource.h"

@interface DSSessionDataSource ()

@property (nonatomic, strong) DSSession *session;

@property (nonatomic, strong) id<DSSessionConfig> sessionConfig;

@property (nonatomic, strong) DSSessionMsgDataSource *dataSource;

@end

@implementation DSSessionDataSource

//暂时预留session 其实只用上了sessionConfig
- (instancetype)initWithSession:(DSSession *)session config:(id<DSSessionConfig>)sessionConfig {
    self = [super init];
    if (self) {
        _session = session;
        _sessionConfig = sessionConfig;
        _dataSource = [[DSSessionMsgDataSource alloc] initWithSession:_session config:_sessionConfig];
    }
    return self;
}

- (NSArray *)items {
    return self.dataSource.items;
}

- (DSSessionMessageOperateResult *)addMessageModels:(NSArray *)models {
    //插入消息后，消息对应的index
    NSArray *indexpaths = [self.dataSource appendMessageModels:models];
    DSSessionMessageOperateResult *result = [[DSSessionMessageOperateResult alloc] init];
    result.indexpaths = indexpaths;
    result.messageModels = models;
    return result;
}

- (DSSessionMessageOperateResult *)insertMessageModels:(NSArray *)models {
    //插入消息后，消息对应的index
    NSArray *indexpaths = [self.dataSource insertMessageModels:models];
    DSSessionMessageOperateResult *result = [[DSSessionMessageOperateResult alloc] init];
    result.indexpaths = indexpaths;
    result.messageModels = models;
    return result;
}

- (DSSessionMessageOperateResult *)deleteMessageModel:(DSMessageModel *)model {
    //要删除的消息对应的index
    NSArray *indexs = [self.dataSource deleteMessageModel:model];
    DSSessionMessageOperateResult *result = [[DSSessionMessageOperateResult alloc] init];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    //这里需要构造成NSIndexPath
    for (NSNumber *index in indexs) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index.integerValue inSection:0];
        [indexPaths addObject:indexPath];
    }
    result.indexpaths = indexPaths;
    result.messageModels = @[model];
    return result;
}

- (DSSessionMessageOperateResult *)updateMessageModel:(DSMessageModel *)model {
    NSInteger index = [self.dataSource indexAtModelArray:model];
    [self.dataSource.items replaceObjectAtIndex:index withObject:model];
    DSSessionMessageOperateResult *result = [[DSSessionMessageOperateResult alloc] init];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    result.indexpaths = @[indexpath];
    result.messageModels = @[model];
    return result;
}

- (NSInteger)indexAtModelArray:(DSMessageModel *)model {
    return [self.dataSource indexAtModelArray:model];
}

- (NSArray *)deleteModels:(NSRange)range {
    return [self.dataSource deleteModels:range];
}

- (DSMessageModel *)findModel:(DSMessage *)message {
    DSMessageModel *model;
    for (DSMessageModel *item in self.dataSource.items.reverseObjectEnumerator.allObjects) {
        if ([item isKindOfClass:[DSMessageModel class]] && [item.message.messageID isEqual:message.messageID]) {
            model = item;
            //防止不是同一个
            model.message = message;
        }
    }
    return model;
}

- (void)resetMessages:(void (^)(NSError *))handler {
    [self.dataSource resetMessages:handler];
}

- (void)loadHistoryMessagesWithComplete:(void (^)(NSInteger, NSArray *, NSError *))handler {
    [self.dataSource loadHistoryMessagesWithComplete:handler];
}


- (void)checkAttachmentState:(NSArray *)messages complete:(void (^)(DSMessage *))complete {
    for (id item in messages) {
        DSMessage *message;
        if ([item isKindOfClass:[DSMessage class]]) {
            message = item;
        }
        if ([item isKindOfClass:[DSMessageModel class]]) {
            message = [(DSMessageModel *)item message];
        }
        //有消息并且有消息附件还没有下载的话，就回调出去
        if (message && message.attachmentDownloadState == DSMessageAttachmentDownloadStateNotDownload) {
            complete(message);
        }
    }
}

- (NSDictionary *)checkReceipt {
    //看是否需要执行已读回执
    BOOL shouldReceipt = self.sessionConfig && [self.sessionConfig respondsToSelector:@selector(shouldHandleReceipt)];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //是否找到找到最后一个已读回执
    BOOL findLastReceipt = NO;
    
    for (NSInteger i = self.dataSource.items.count - 1; i >= 0; i--) {
        id item = [self.dataSource.items objectAtIndex:i];
        if ([item isKindOfClass:[DSMessageModel class]]) {
            DSMessageModel *model = (DSMessageModel *)item;
            DSMessage *message = model.message;
            //是发送出去的消息
            if (message.isSendMsg) {
                if (!findLastReceipt) {
                    //对方已读，并且要处理已读，这条消息是否支持已读处理
                    if (message.isRemoteRead && shouldReceipt && [self.sessionConfig shouldHandleReceiptForMessage:message]) {
                        //已经展示已读了
                        if (model.shouldShowReadLabel) {
                            break;
                        }else {
                            dic[@(i)] = model;
                            model.shouldShowReadLabel = YES;
                            findLastReceipt = YES;
                        }
                    }
                }
                else {
                    //找到原来标记已读的数据 不再标记
                    if (model.shouldShowReadLabel) {
                        dic[@(i)] = model;
                        model.shouldShowReadLabel = NO;
                        //只需要一个已读标记在UI,所以找到就可以跳出
                        break;
                    }
                }
            }
        }
    }
    return dic;
}


- (void)sendMessageReceipt:(NSArray *)messages complete:(void (^)(DSMessage *))complete {
    //当前应用处于Active状态
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        //找到最后一个需要发送已读回执的消息
        for (NSInteger i = messages.count - 1; i >= 0; i--) {
            id item = [messages objectAtIndex:i];
            DSMessage *message = nil;
            if ([item isKindOfClass:[DSMessage class]]) {
                message = item;
            }
            else if ([item isKindOfClass:[DSMessageModel class]]) {
                message = [(DSMessageModel *)item message];
            }
            if (message) {
                //这条消息不是自己发的 并且支持已读回执
                if (!message.isSendMsg && self.sessionConfig && [self.sessionConfig respondsToSelector:@selector(shouldHandleReceiptForMessage:)]) {
                    complete(message);
                    return ;
                }
            }
        }
    }
}

@end

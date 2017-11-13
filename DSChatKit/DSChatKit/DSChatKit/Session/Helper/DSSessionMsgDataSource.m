//
//  DSSessionMsgDataSource.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionMsgDataSource.h"
#import "DSChatKitMessageProvider.h"
#import "DSMessageModel.h"
#import "DSChatKitMacro.h"
#import "DSTimestampModel.h"

@interface DSSessionMsgDataSource()

//数据提供
@property (nonatomic, strong) id<DSChatKitMessageProvider> dataProvide;

@property (nonatomic, strong) NSMutableDictionary *msgIdDic;

@end

@implementation DSSessionMsgDataSource {
    DSSession *_session; //当前会话
}
- (instancetype)initWithSession:(DSSession *)session config:(id<DSSessionConfig>)sessionConfig {
    self = [super init];
    if (self) {
        _session = session;
        _sessionConfig = sessionConfig;
        _dataProvide = [_sessionConfig respondsToSelector:@selector(messageDataProvider)] ? [_sessionConfig messageDataProvider] : nil;
        if (_sessionConfig.messageLimit <= 0) {
            _messageLimit = 20;
        }else {
            _messageLimit = _sessionConfig.messageLimit;
        }
        if (_sessionConfig.showTimestampInterval <= 0) {
            _showTimeInterval = 300; //5min
        }else {
            _showTimeInterval = _sessionConfig.showTimestampInterval;
        }
        _items = [NSMutableArray array];
        //用消息的唯一ID做为key保存消息
        _msgIdDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)resetMessages:(void(^)(NSError *error))handle {
    self.items = [NSMutableArray array];
    self.msgIdDic = [NSMutableDictionary dictionary];
    __weak typeof(self) wself = self;
    //从服务器拉取
    if ([self.dataProvide respondsToSelector:@selector(pullDownServer:handler:)]) {
        [self.dataProvide pullDownServer:nil handler:^(NSError *error, NSArray<DSMessage *> *messages) {
            DS_Dispatch_Async_Main(^{
                [wself appendMessageModels:[self modelsWithMessages:messages]];
                if (handle) {
                    handle(error);
                }
            });
        }];
    }
    //从本地拉取
    if (self.dataProvide && [self.dataProvide respondsToSelector:@selector(pullDownLocal:messagesInSession:limit:handler:)]) {
        [self.dataProvide pullDownLocal:nil messagesInSession:_session limit:_messageLimit handler:^(NSError *error, NSArray<DSMessage *> *messages) {
            DS_Dispatch_Async_Main(^{
                [wself appendMessageModels:[self modelsWithMessages:messages]];
                if (handle) {
                    handle(nil);
                }
            });
        }];
    }
    
}

/**
 从头插入消息
 
 @param messages 消息
 @return 插入后table要滑动到的位置
 */
- (NSInteger)insertMessages:(NSArray *)messages {
    NSInteger count = self.items.count;
    for (DSMessage *message in messages.reverseObjectEnumerator.allObjects) {
        [self insertMessage:message];
    }
    NSInteger currentIndex = self.items.count - 1;
    //插入之后的长度 - 原来的长度
    return currentIndex - count;
    
}


/**
 从后插入消息
 
 @param models 消息集合
 @return 插入的消息的index
 */
- (NSArray *)appendMessageModels:(NSArray *)models {
    if (!models.count) return @[];
    
    NSMutableArray *append = [NSMutableArray array];
    for (DSMessageModel *model in models) {
        if ([self modelIsExist:model]) continue;
        NSArray *result = [self insertMessageModel:model index:self.items.count];
        //result存的是消息对应的index
        [append addObjectsFromArray:result];
    }
    return append;
}


/**
 从中间插入消息

 @param models 消息集合
 @return 插入消息的index
 */
- (NSArray *)insertMessageModels:(NSArray *)models {
    if (!models.count) return @[];
    NSMutableArray *inserts = [NSMutableArray array];
    //排序，保证先插入的是时间小的
    NSArray *sortModels = [models sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        DSMessageModel *first = obj1;
        DSMessageModel *second = obj2;
        return first.messageTime < second.messageTime ? NSOrderedAscending : NSOrderedDescending;
    }];
    for (DSMessageModel *model in sortModels) {
        if ([self modelIsExist:model]) continue;
        NSInteger i = [self findInsertPosistion:model];
        NSArray *result = [self insertMessageModel:model index:i];
        [inserts addObjectsFromArray:result];
    }
    return inserts;
}

//返回model所在的index
- (NSInteger)indexAtModelArray:(DSMessageModel *)model {
    __block NSInteger index = -1;
    //不存在
    if (![_msgIdDic objectForKey:model.message.messageID]) return index;
    
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DSMessageModel class]]) {
            if ([model isEqual:obj]) {
                index = idx;
                *stop = YES;
            }
        }
    }];
    return index;
}

#pragma mark - msg

//判断是否消息是否存在
- (BOOL)modelIsExist:(DSMessageModel *)model {
    return [_msgIdDic objectForKey:model.message.messageID] != nil;
}

- (void)loadHistoryMessagesWithComplete:(void (^)(NSInteger index, NSArray *, NSError *))handler {
    
    __block DSMessageModel *currentOldMsg = nil;
    //找到当前的第一条消息
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DSMessageModel class]]) {
            currentOldMsg = (DSMessageModel *)obj;
            *stop = YES;
        }
    }];
    //从服务器拉取更多数据
    __weak typeof(self) wself = self;
    if (self.dataProvide && [self.dataProvide respondsToSelector:@selector(pullDownServer:handler:)]) {
        [self.dataProvide pullDownServer:currentOldMsg.message handler:^(NSError *error, NSArray<DSMessage *> *messages) {
            DS_Dispatch_Async_Main(^{
                NSInteger index = [wself insertMessages:messages];
                if (handler) {
                    handler(index,messages,error);
                }
            });
        }];
        return;
    }
    //从本地拉取更多数据
    if (self.dataProvide && [self.dataProvide respondsToSelector:@selector(pullDownLocal:messagesInSession:limit:handler:)]) {
        [self.dataProvide pullDownLocal:currentOldMsg.message messagesInSession:_session limit:self.messageLimit handler:^(NSError *error, NSArray<DSMessage *> *messages) {
            NSInteger index = [wself insertMessages:messages];
            if (handler) {
                DS_Dispatch_Async_Main(^{
                    handler(index,messages,error);
                });
            }
        }];
    }
}


//删除消息
- (NSArray *)deleteMessageModel:(DSMessageModel *)msgModel {
    NSMutableArray *dels = [NSMutableArray array];
    NSInteger delTimeIndex = -1;
    //这条消息的index
    NSInteger delMsgIndex = [self.items indexOfObject:msgModel];
    
    if (delMsgIndex > 0) {
        //此消息是最后一条 或者是 下一条是时间戳 并且此消息上一条是时间戳 删掉时间戳
        BOOL delMsgIsSingle = (delMsgIndex == self.items.count - 1 || [self.items[delMsgIndex + 1] isKindOfClass:[DSTimestampModel class]]);
        if ([self.items[delMsgIndex - 1] isKindOfClass:[DSTimestampModel class]] && delMsgIsSingle) {
            delTimeIndex = delMsgIndex - 1;
            [self.items removeObjectAtIndex:delTimeIndex];
            [dels addObject:@(delTimeIndex)];
        }
    }
    //删掉消息
    if (delMsgIndex > -1) {
        [self.items removeObject:msgModel];
        [_msgIdDic removeObjectForKey:msgModel.message.messageID];
        [dels addObject:@(delMsgIndex)];
    }
    return dels;
}

//删除消息
- (NSArray <NSIndexPath *> *)deleteModels:(NSRange)range {
    NSArray *models = [self.items subarrayWithRange:range];
    NSMutableArray *dels = [NSMutableArray array];
    NSMutableArray *all = [NSMutableArray arrayWithArray:self.items];
    for (DSMessageModel *model in models) {
        //时间戳直接跳过
        if ([model isKindOfClass:[DSTimestampModel class]]) continue;
        
        NSInteger delTimeIndex = -1;
        NSInteger delMsgIndex = [all indexOfObject:model];
        //删除时间戳
        if (delMsgIndex > 0) {
            BOOL delMsgIsSingle = (delMsgIndex == all.count - 1 || [all[delMsgIndex + 1] isKindOfClass:[DSTimestampModel class]]);
            if ([all[delMsgIndex - 1] isKindOfClass:[DSTimestampModel class]] && delMsgIsSingle) {
                delTimeIndex = delMsgIndex - 1;
                [self.items removeObjectAtIndex:delTimeIndex];
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:delTimeIndex inSection:0];
                [dels addObject:indexpath];
            }
        }
        if (delMsgIndex > -1) {
            [self.items removeObject:model];
            [_msgIdDic removeObjectForKey:model.message.messageID];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:delMsgIndex inSection:0];
            [dels addObject:indexPath];
        }
    }
    return dels;
}


#pragma mark - private

//插入消息
- (void)insertMessage:(DSMessage *)message {
    
    DSMessageModel *model = [[DSMessageModel alloc] initWithMessage:message];
    //消息已经存在了，直接返回
    if ([self modelIsExist:model]) return;
    
    
    NSTimeInterval firstTimeInterval = [self firstTimeInterval];
    if (firstTimeInterval && firstTimeInterval - model.messageTime < self.showTimeInterval) {
        //此时至少有一条消息和时间戳(如果有的话)
        //删掉时间戳(如果有的话)
        if ([self.items.firstObject isKindOfClass:[DSTimestampModel class]]) {
            [self.items removeObjectAtIndex:0];
        }
    }
    
    [self.items insertObject:model atIndex:0];
    
    if (![self.dataProvide respondsToSelector:@selector(needTimetag)] || self.dataProvide.needTimetag) {
        //这种情况下必须插入时间戳
        DSTimestampModel *timeModel = [[DSTimestampModel alloc] init];
        timeModel.messageTime = model.messageTime;
        [self.items insertObject:timeModel atIndex:0];
    }
    
    [self.msgIdDic setObject:model forKey:model.message.messageID];
}

//在index位置插入消息
- (NSArray *)insertMessageModel:(DSMessageModel *)model index:(NSInteger)index {
    NSMutableArray * inserts = [NSMutableArray array];
    if (![self.dataProvide respondsToSelector:@selector(needTimetag)] || self.dataProvide.needTimetag) {
        if ([self shouldInsertTimestamp:model]) {
            DSTimestampModel *timeModel = [[DSTimestampModel alloc] init];
            timeModel.messageTime = model.messageTime;
            [self.items insertObject:timeModel atIndex:index];
            [inserts addObject:@(index)];
            index++;
        }
    }
    [self.items insertObject:model atIndex:index];
    [self.msgIdDic setObject:model forKey:model.message.messageID];
    [inserts addObject:@(index)];
    return inserts;
}

//删除count位置前的消息
- (void)subHeadMessages:(NSInteger)count {
    NSInteger catch = 0;
    NSArray *modelArray = [NSArray arrayWithArray:self.items];
    for (DSMessageModel *model in modelArray) {
        if ([model isKindOfClass:[DSMessageModel class]]) {
            catch++;
            [self deleteMessageModel:model];
        }
        if (catch == count) {
            break;
        }
    }}

// 找到这条消息要插入的index
- (NSInteger)findInsertPosistion:(DSMessageModel *)model {
    return [self findInsertPosistion:self.items model:model];
}

//找到这条消息要插入在array数组中的index
- (NSInteger)findInsertPosistion:(NSArray *)array model:(DSMessageModel *)model {
    //当前没消息直接放第一个
    if (array.count == 0) return 0;
    if (array.count == 1) {
        //递归的出口
        DSMessageModel *obj = array.firstObject;
        NSInteger index = [self.items indexOfObject:obj];
        return obj.messageTime > model.messageTime ? index : index + 1;
    }
    //二分查找
    NSInteger sep = (array.count - 1) / 2;
    DSMessageModel *center = array[sep];
    NSTimeInterval timestamp = center.messageTime;
    NSArray *half;
    if (timestamp <= model.messageTime) {
        half = [array subarrayWithRange:NSMakeRange(sep, array.count - sep)];
    }else {
        half = [array subarrayWithRange:NSMakeRange(0, sep)];
    }
    return [self findInsertPosistion:half model:model];
    
}

//将DSMessage构造成DSMessageModel模型
- (NSArray <DSMessageModel *> *)modelsWithMessages:(NSArray <DSMessage *>*)messages {
    NSMutableArray *array = [NSMutableArray array];
    for (DSMessage *message in messages) {
        DSMessageModel *model = [[DSMessageModel alloc] initWithMessage:message];
        [array addObject:model];
    }
    return array;
}


//是否需要插入时间戳
- (BOOL)shouldInsertTimestamp:(DSMessageModel *)model {
    NSTimeInterval lastTimeInterval = [self lastTimeInterval];
    return model.messageTime - lastTimeInterval > self.showTimeInterval;
}


//第一条消息时间
- (NSTimeInterval)firstTimeInterval {
    if (!self.items.count) return 0;
    DSMessageModel *model;
    if (![self.dataProvide respondsToSelector:@selector(needTimetag)] || self.dataProvide.needTimetag) {
        model = self.items[1];
    } else {
        model = self.items[0];
    }
    return model.messageTime;
    
}

//最后一条消息时间
- (NSTimeInterval)lastTimeInterval {
    DSMessageModel *model = self.items.lastObject;
    return model.messageTime;
}

@end

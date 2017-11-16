//
//  DSSessionPrivateProtocol.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/15.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#ifndef DSSessionPrivateProtocol_h
#define DSSessionPrivateProtocol_h

#import "DSSessionViewController.h"

#import <Foundation/Foundation.h>

//消息操作结果
@interface DSSessionMessageOperateResult : NSObject
//消息对应的indexpaths
@property (nonatomic,copy) NSArray *indexpaths;
//消息数据
@property (nonatomic,copy) NSArray *messageModels;

@end

@protocol DSSessionDataSourceProtocol <NSObject>

//消息数据源
- (NSArray *)items;
//从后插入消息
- (DSSessionMessageOperateResult *)addMessageModels:(NSArray *)models;
//从中间插入消息
- (DSSessionMessageOperateResult *)insertMessageModels:(NSArray *)models;
//删除消息
- (DSSessionMessageOperateResult *)deleteMessageModel:(DSMessageModel *)model;
//更新消息
- (DSSessionMessageOperateResult *)updateMessageModel:(DSMessageModel *)model;
//找到message对应的消息model
- (DSMessageModel *)findModel:(DSMessage *)message;
//消息model对应的index
- (NSInteger)indexAtModelArray:(DSMessageModel *)model;
//批量删除消息
- (NSArray *)deleteModels:(NSRange)range;
//复位消息
- (void)resetMessages:(void(^)(NSError *error))handler;
//加载历史消息
- (void)loadHistoryMessagesWithComplete:(void(^)(NSInteger index, NSArray *messages , NSError *error))handler;
//检查附件下载状态，如果没有下载则回调该消息
- (void)checkAttachmentState:(NSArray *)messages complete:(void (^)(DSMessage *))complete;
//检查已读回执是否需要显示，显示在哪里
- (NSDictionary *)checkReceipt;
//发送已读回执 将该消息回调出来
- (void)sendMessageReceipt:(NSArray *)messages complete:(void (^)(DSMessage *))complete;
@end

@protocol DSSessionLayoutProtocolDelegate <NSObject>
//用于下拉刷新
- (void)refresh;

@end

@protocol DSSessionLayoutProtocol <NSObject>
//更新消息
- (void)update:(NSIndexPath *)indexPath;
//插入消息
- (void)insert:(NSArray *)indexPaths animated:(BOOL)animated;
//删除消息
- (void)remove:(NSArray *)indexPaths;
//计算内容大小
- (void)calculateContent:(DSMessageModel *)model;
//刷新tableView;
- (void)reloadTable;
//重置布局
- (void)resetLayout;
//改变键盘高度
- (void)changeLayout:(CGFloat)inputViewHeight;
//设置代理
- (void)setDelegate:(id<DSSessionLayoutProtocolDelegate>)delegate;
//下拉刷新之后计算布局
- (void)layoutAfterRefresh;

@end

#endif

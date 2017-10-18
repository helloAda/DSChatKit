//
//  DSInputAtCache.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DSInputAtStartChar @"@"
#define DSInputAtEndChar   @"\u2004" // Unicode 空格

@interface DSInputAtItem : NSObject
//名字
@property (nonatomic, copy) NSString *name;
//id
@property (nonatomic, copy) NSString *uid;
//范围
@property (nonatomic, assign) NSRange range;

@end


@interface DSInputAtCache : NSObject


/**
 匹配出所有被@的名字

 @param sendText 被匹配的字符串
 @return 匹配结果数组
 */
- (NSArray *)allAtUid:(NSString *)sendText;

//删除所有数据
- (void)clean;

//添加数据
- (void)addAtItem:(DSInputAtItem *)item;

//通过名字找到对应数据
- (DSInputAtItem *)item:(NSString *)name;

//通过名字移除对应数据
- (DSInputAtItem *)removeName:(NSString *)name;

@end

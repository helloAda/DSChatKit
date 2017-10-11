//
//  DSInputEmojiManager.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

//表情数据模型
@interface DSInputEmoji : NSObject
//表情id
@property (nonatomic, strong) NSString *emojiID;
//表情tag 例如 [可爱]
@property (nonatomic, strong) NSString *tag;
//表情名称 例如xxx.png
@property (nonatomic, strong) NSString *fileName;

@end

//表情目录数据模型
@interface DSInputEmojiCatalogs : NSObject
//目录id
@property (nonatomic, copy) NSString *catalogID;
//目录标题
@property (nonatomic, copy) NSString *title;
//目录图片
@property (nonatomic, copy) NSString *icon;
//目录选中图片
@property (nonatomic, copy) NSString *iconSelected;
//所有表情数据 @[DSInputEmoji,...]
@property (nonatomic, strong) NSArray *emojis;
//用表情id(DSInputEmoji.emojiID)做为key 存DSInputEmoji
@property (nonatomic, strong) NSDictionary *idEmoji;
//用表情的tag(DSInputEmoji.tag)做为key 存DSInputEmoji
@property (nonatomic, strong) NSDictionary *tagEmoji;
//页数
@property (nonatomic, assign) NSInteger pagesCount;

@end

//表情管理类
@interface DSInputEmojiManager : NSObject

+ (instancetype)manager;



@end

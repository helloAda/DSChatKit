//
//  DSInputEmojiManager.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define EmojiPath       @"Emoji"    //在bundle中的文件夹名称
#define EmojiCatalog    @"default"  //emoji表情目录ID所对应的Key

#define EmojiRow 3
#define EmojiMargin 15
#define EmojiMarginTop 15
#define EmojiImageWidth 40
#define EmojiImageHeight 40
#define EmojiHeight 43

//表情包
#define EmoticonRow 2
#define EmoticonImageWidth 70
#define EmoticonImageHeight 70
#define EmoticonHeight 76

//表情布局
@interface DSInputEmojiLayout : NSObject
//行数
@property (nonatomic, assign) NSInteger rows;
//列数
@property (nonatomic, assign) NSInteger columes;
//每页显示几项
@property (nonatomic, assign) NSInteger itemCountInPage;
//每个表情宽度
@property (nonatomic, assign) CGFloat emojiWidth;
//每个表情高度
@property (nonatomic, assign) CGFloat emojiHeight;
//图片的宽
@property (nonatomic, assign) CGFloat imageWidth;
//图片的高
@property (nonatomic, assign) CGFloat imageHeight;
//是否emoji图片
@property (nonatomic, assign) BOOL emoji;

//初始化emoji布局
- (instancetype)initEmojiLayout:(CGFloat)width;

//初始化表情包布局
- (instancetype)initEmoticonLayout:(CGFloat)width;

@end

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
@interface DSInputEmojiCatalog : NSObject
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
//布局对象
@property (nonatomic, assign) DSInputEmojiLayout *layout;

@end

//表情管理类
@interface DSInputEmojiManager : NSObject

+ (instancetype)manager;

//通过这组表情对应的目录id找到表情数据
- (DSInputEmojiCatalog *)emojiCatalog:(NSString *)catalogID;



@end

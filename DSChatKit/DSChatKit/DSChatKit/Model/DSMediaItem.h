//
//  DSMediaItem.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/7.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//多媒体按钮数据模型
@interface DSMediaItem : NSObject

@property (nonatomic, assign) SEL selctor;

@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, copy) NSString *title;


/**
 初始化

 @param selector 方法名称
 @param normalImage 图片
 @param selectedImage 选中图片
 @param title 标题
 @return 实例
 */
+ (DSMediaItem *)item:(NSString *)selector
          normalImage:(UIImage *)normalImage
        selectedImage:(UIImage *)selectedImage
                title:(NSString *)title;
@end

//
//  DSChatKitInfo.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/22.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DSChatKitInfo : NSObject

//ID 用户信息为用户id 群信息 为群id
@property (nonatomic, copy) NSString *infoId;

//显示名
@property (nonatomic, copy) NSString *showName;

//头像url
@property (nonatomic, copy) NSString *avatarUrlString;

//头像图片
@property (nonatomic, strong) UIImage *avatarImage;

@end

//
//  DSChatKit.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/12.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSChatKit : NSObject


+ (instancetype)shareKit;

//表情资源所在的bundle名称
@property (nonatomic, copy) NSString *emojiBundleName;

@end

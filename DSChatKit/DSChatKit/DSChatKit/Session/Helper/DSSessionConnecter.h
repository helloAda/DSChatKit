//
//  DSSessionConnecter.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSSessionViewController;
//接口连接器
@interface DSSessionConnecter : NSObject

//将数据，排版，逻辑等与控制器连接，不用耦合在一起。
- (void)connect:(DSSessionViewController *)vc;

@end

//
//  DSSessionViewController.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/18.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSSessionConfig.h"

@interface DSSessionViewController : UIViewController


// 会话详细配置 继承后需要重写一下
- (id<DSSessionConfig>)sessionConfig;

@end

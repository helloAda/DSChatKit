//
//  DSVideoObjcet.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSMessageObject.h"

@interface DSVideoObjcet : NSObject<DSMessageObject>

//视频封面的本地路径
@property (nullable, nonatomic, copy, readonly) NSString *coverPath;

@end

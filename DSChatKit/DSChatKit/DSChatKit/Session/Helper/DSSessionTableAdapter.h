//
//  DSSessionTableAdapter.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSessionConfigurateProtocol.h"
#import "DSMessageCellDelegate.h"

//数据源(DataSource)和排版(Layout)对象的适配器
@interface DSSessionTableAdapter : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id <DSSessionInteractorProtocol> interactor;

@property (nonatomic, weak) id <DSMessageCellDelegate> delegate;

@end

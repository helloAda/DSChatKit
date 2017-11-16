//
//  UITableView+DSCategory.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/16.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "UITableView+DSCategory.h"

@implementation UITableView (DSCategory)

- (void)ds_scrollToBottom:(BOOL)animation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger row = [self numberOfRowsInSection:0] - 1;
        if (row > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:animation];
        }
    });
}

@end

//
//  DSSessionTableAdapter.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionTableAdapter.h"
#import "DSMessageCellFactory.h"
#import "UIView+DSCategory.h"

@interface DSSessionTableAdapter ()
// cell 工厂
@property (nonatomic, strong) DSMessageCellFactory *cellFactory;

@end

@implementation DSSessionTableAdapter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellFactory = [[DSMessageCellFactory alloc] init];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.interactor items].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //取出这一行的数据
    id model = [[self.interactor items] objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[DSMessageModel class]]) {
        cell = [self.cellFactory cellInTable:tableView forMessageMode:model];
        
        [(DSMessageCell *)cell setDelegate:self.delegate];
        [(DSMessageCell *)cell refreshData:model];
    }
    else if ([model isKindOfClass:[DSTimestampModel class]]) {
        cell = [self.cellFactory cellInTable:tableView forTimeMode:model];
    }
    else {
        NSAssert(0,@"DSSessionTableAdapter.m, 展示cell不支持该数据模型");
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0;
    id modelInArray = [[self.interactor items] objectAtIndex:indexPath.row];
    if ([modelInArray isKindOfClass:[DSMessageModel class]]) {
        DSMessageModel *model = (DSMessageModel *)modelInArray;
        CGSize size = [model contentSize:tableView.width];
        UIEdgeInsets contentViewInsets = model.contentViewInsets;
        UIEdgeInsets bubbleViewInsets = model.bubbleViewInsets;
        cellHeight = size.height + contentViewInsets.top + contentViewInsets.bottom + bubbleViewInsets.top + bubbleViewInsets.bottom;
    }
    else if ([modelInArray isKindOfClass:[DSTimestampModel class]]) {
        
        cellHeight = [(DSTimestampModel *)modelInArray height];
        
    }else {
        NSAssert(0,@"DSSessionTableAdapter.m , 计算高度不支持该数据模型");
    }
    return cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滑动就将菜单隐藏
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

@end

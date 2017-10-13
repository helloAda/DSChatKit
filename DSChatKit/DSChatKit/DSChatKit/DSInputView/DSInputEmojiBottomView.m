//
//  DSInputEmojiBottomView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputEmojiBottomView.h"
#import "UIView+DSCategory.h"
#import "DSInputEmojiManager.h"
#import "UIImage+DSCategory.h"
#import "DSChatKit.h"

const NSInteger DSInputEmojiBottomViewHieght = 35; //高度
const NSInteger DSInputEmojiSendButtonWidth  = 40; //发送按钮高度
const NSInteger DSInpitEmojiAddButtonWidth   = 35; //添加按钮宽度

const CGFloat separatedLineWidth = .5f; //分隔线宽度

@interface DSInputEmojiBottomView ()
//目录按钮
@property (nonatomic, strong) NSMutableArray *catalogs;
//分割线
@property (nonatomic, strong) NSMutableArray *separatedLines;

@end

@implementation DSInputEmojiBottomView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _catalogs = [NSMutableArray array];
        _separatedLines = [NSMutableArray array];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _sendButton.backgroundColor = [UIColor blueColor];
        _sendButton.width = DSInputEmojiSendButtonWidth;
        _sendButton.height = DSInputEmojiBottomViewHieght;
        [self addSubview:_sendButton];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _addButton.width = DSInpitEmojiAddButtonWidth;
        _addButton.height = DSInputEmojiBottomViewHieght;
        [self addSubview:_addButton];
        
        _catalogsView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _catalogsView.showsVerticalScrollIndicator = NO;
        _catalogsView.showsHorizontalScrollIndicator = NO;
        _catalogsView.scrollsToTop = NO;
        [self addSubview:_catalogsView];
        
    }
    return self;
}


- (void)loadCatalogs:(NSArray *)emojiCatalogs {
    for (UIView *subView in [_catalogs arrayByAddingObjectsFromArray:_separatedLines]) {
        [subView removeFromSuperview];
    }
    [_catalogs removeAllObjects];
    [_separatedLines removeAllObjects];
    
    for (DSInputEmojiCatalog *catalog in emojiCatalogs) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage ds_fetchBundleImage:catalog.icon bundleName:[DSChatKit shareKit].emojiBundleName] forState:UIControlStateNormal];
        [btn setImage:[UIImage ds_fetchBundleImage:catalog.iconSelected bundleName:[DSChatKit shareKit].emojiBundleName] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(onTouchCatalogs:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        [_catalogsView addSubview:btn];
        [_catalogs addObject:btn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 5, separatedLineWidth, DSInputEmojiBottomViewHieght - 10)];
        line.backgroundColor = [UIColor lightTextColor];
        [_catalogsView addSubview:line];
        [_separatedLines addObject:line];
    }
}


- (void)onTouchCatalogs:(UIButton *)btn {
    NSInteger index = [self.catalogs indexOfObject:btn];
    [self selectIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didSelectBottomIndex:)]) {
        [self.delegate bottomView:self didSelectBottomIndex:index];
    }
}

- (void)selectIndex:(NSInteger)index {
    UIButton *btn;
    for (NSInteger i = 0; i < self.catalogs.count; i++) {
        btn = self.catalogs[i];
        btn.selected = i == index;
    }
    //btn没有在可见区域要滚动
    //右边
    if (btn.left == (_catalogsView.contentOffset.x + _catalogsView.width)) {
        [_catalogsView scrollRectToVisible:CGRectMake(_catalogsView.contentOffset.x + btn.width, 0, _catalogsView.width, _catalogsView.height) animated:YES];
    }
    //左边
    if (btn.right == _catalogsView.contentOffset.x) {
        [_catalogsView scrollRectToVisible:CGRectMake(_catalogsView.contentOffset.x - btn.width, 0, _catalogsView.width, _catalogsView.height) animated:YES];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _addButton.left = 0;
    _addButton.top = 0;
    _sendButton.right = self.width;
    _sendButton.top = 0;
    _catalogsView.frame = CGRectMake(_addButton.right, 0, self.width - _addButton.width - _sendButton.width, self.height);
    CGFloat left = 0;
    for (NSInteger index = 0; index < self.catalogs.count; index++) {
        UIButton *btn = self.catalogs[index];
        btn.left = left;
        btn.centerY = self.height *.5f;
        
        UIView *line = self.separatedLines[index];
        line.left = btn.right;
        left = line.right;
    }
    
    _catalogsView.contentSize = CGSizeMake(left, self.height);
}
@end

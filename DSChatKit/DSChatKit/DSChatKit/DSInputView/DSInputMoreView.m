//
//  DSInputMoreView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/6.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputMoreView.h"
#import "DSPageView.h"
#import "UIView+DSCategory.h"

#define TitleFontSize 14

#define MaxItemCountInPage 8 //每页最多8个
#define PageRowCount 2       //分2行
#define PageColumnCount 4    //每行4个

@interface DSInputMoreView ()<DSPageViewDataSource,DSPageViewDelegate>
{
    NSArray *_mediaButtons;//存按钮
    NSArray *_mediaItems;//存按钮数据
}

@property (nonatomic, strong) DSPageView *pageView;

@end

@implementation DSInputMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageView = [[DSPageView alloc] initWithFrame:self.bounds];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pageView.dataSource = self;
        [self addSubview:_pageView];
    }
    return self;
}

//设置按钮
- (void)setupMediaButtons {
    
    NSMutableArray *mediaButtons = [NSMutableArray array];
    NSMutableArray *mediaItems = [NSMutableArray array];
    NSArray *items; //存多媒体item数据的
    if (self.config && [self.config respondsToSelector:@selector(mediaItems)]) {
        items = [self.config mediaItems];
    }
    
    [items enumerateObjectsUsingBlock:^(DSMediaItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        [mediaItems addObject:item];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = idx;
        [btn setImage:item.normalImage forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateHighlighted];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTintColor:[UIColor lightTextColor]];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(76, -75, 0, 0)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:TitleFontSize]];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [mediaButtons addObject:btn];
    }];
    _mediaButtons = mediaButtons;
    _mediaItems = mediaItems;
}


- (void)setFrame:(CGRect)frame {
    CGFloat originalWidth = self.width;
    [super setFrame:frame];
    if (originalWidth != frame.size.width) {
        [self.pageView reloadData];
    }
}

- (void)dealloc {
    _pageView.dataSource = nil;
}

#pragma mark --- DSPageViewDataSource

- (NSInteger)numberOfPages:(DSPageView *)pageView {
    NSInteger pageNum = _mediaButtons.count / MaxItemCountInPage;
    pageNum = (_mediaButtons.count % MaxItemCountInPage == 0) ? pageNum : pageNum + 1;
    return MAX(pageNum, 1);
}

- (UIView *)pageView:(DSPageView *)pageView viewInPage:(NSInteger)index {
    if (index < 0) {
        assert(0);
        index = 0;
    }
    NSInteger begin = index * MaxItemCountInPage;
    NSInteger end = (index + 1) * MaxItemCountInPage;
    if (end > _mediaButtons.count) {
        end = _mediaButtons.count;
    }
    return [self mediaPageView:pageView beginItem:begin endItem:end];
}

- (UIView *)mediaPageView:(DSPageView *)pageView beginItem:(NSInteger)begin endItem:(NSInteger)end {
    UIView *subView = [[UIView alloc] init];
    NSInteger spacing = self.width - PageColumnCount *
}


@end

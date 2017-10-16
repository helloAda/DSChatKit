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
#define ButtonItemWidth 60   //按钮宽度
#define ButtonItemHeight 80  //按钮高度

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
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(61, -60, 0, 0)];
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
    //间距
    NSInteger spacing = (self.width - PageColumnCount * ButtonItemWidth) / (PageColumnCount + 1);
    NSInteger coloumnIndex = 0; //第几列
    NSInteger rowIndex = 0;     //第几行
    NSInteger indexPage = 0;    //第几个
    
    for (NSInteger index = begin ; index < end; index ++) {
        UIButton *button = [_mediaButtons objectAtIndex:index];
        [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        
        rowIndex = indexPage / PageColumnCount;
        coloumnIndex = indexPage % PageColumnCount;
        CGFloat x = spacing + (ButtonItemWidth + spacing) * coloumnIndex;
        CGFloat y = 0.0;
        if (rowIndex > 0) {
            y = rowIndex * (ButtonItemHeight + 10) + 10;
        }
        else {
            y = 10;
        }
        button.frame = CGRectMake(x, y, ButtonItemWidth, ButtonItemHeight);
        [subView addSubview:button];
        indexPage++;
    }
    return subView;
}

#pragma mark --- button action
- (void)onTouchButton:(UIButton *)button {
    NSInteger index = button.tag;
    DSMediaItem *item = _mediaItems[index];
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(didTapMediaItem:)]) {
        BOOL handled = [self.actionDelegate didTapMediaItem:item];
        if (!handled) NSAssert(0,@"无效的按钮响应方法");
    }
}
@end

//
//  DSPageView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/6.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSPageView;

//page数组源
@protocol DSPageViewDataSource <NSObject>
//总共有几页
- (NSInteger)numberOfPages:(DSPageView *)pageView;
//每页对应的视图
- (UIView *)pageView:(DSPageView *)pageView viewInPage:(NSInteger)index;
@end

//page代理
@protocol DSPageViewDelegate <NSObject>
@optional
//滑动结束
- (void)pageViewScrollEnd:(DSPageView *)page currentIndex:(NSInteger)index totolPage:(NSInteger)pages;
//滑动时
- (void)pageViewDidScroll:(DSPageView *)pageView;
//是否需要滑动动画
- (BOOL)needScrollAnimation;

@end

@interface DSPageView : UIView<UIScrollViewDelegate>

//滑动视图
@property (nonatomic, strong) UIScrollView *scrollView;
//数据源
@property (nonatomic, weak) id<DSPageViewDataSource> dataSource;
//代理
@property (nonatomic, weak) id<DSPageViewDelegate> delegate;
//滚动到指定页
- (void)scrollToPage: (NSInteger)pages;
//重新加载数据
- (void)reloadData;
//返回指定页的view
- (UIView *)viewAtIndex: (NSInteger)index;
//当前页
- (NSInteger)currentPage;

//旋转相关，务必调用。
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration;
@end

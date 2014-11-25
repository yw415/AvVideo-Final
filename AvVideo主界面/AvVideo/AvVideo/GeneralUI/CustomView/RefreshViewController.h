//
//  RefreshViewController.h
//  CoreDataFlipPage
//
//  Created by user on 14-8-16.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "General_ViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

typedef enum {
    haveHeadRefreshView,
    haveRootRefreshView,
    haveBothRefreshView,
} RefrshViewState;

typedef void (^RefreshData) (int page);

@interface RefreshViewController : General_ViewController<EGORefreshTableDelegate>
@property(nonatomic,assign)RefrshViewState refreshState;
@property(nonatomic,assign)id<UITableViewDataSource>tableDataSource;
@property(nonatomic,assign)id<UITableViewDelegate>tableDelegate;
@property(nonatomic,copy)RefreshData refreshDataBlock;
/// 把scroll与刷新控件关联
-(void)relateScroll;
/// 把scrollEnd与刷新控件关联
-(void)relateScrollEnd;
/// 强制刷新
-(void)refresh;
@end

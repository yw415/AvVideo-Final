//
//  MainViewController.m
//  GeneralFramework
//
//  Created by user on 14-8-5.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "MainViewController.h"
#import "ConfigSDK.h"
#import "HttpRequestSDK.h"
#import "UtilitySDK.h"
#import "CoreDataManager.h"
#import "RefreshViewController.h"
#import "VideoRow.h"
#define CellHeight 90
#define PageSize 10
@interface MainViewController ()
@property(nonatomic,strong)NSFetchedResultsController * data;
@property(nonatomic,strong)RefreshViewController * refreshView;
@end

@implementation MainViewController

#pragma mark - 界面生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.refreshView refresh];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"首页";
    self.view.backgroundColor=[UIColor whiteColor];
    [self addSubViews];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI相关方法
/// 添加子视图
-(void)addSubViews
{
    __weak MainViewController * tempView =self;
    // 查询数据
    [self getDataWithPage:0 pageSize:PageSize];
    
    self.refreshView =[[RefreshViewController alloc]init];
    self.refreshView.tableDataSource=self;
    self.refreshView.tableDelegate=self;
    self.refreshView.refreshState=haveBothRefreshView;
    self.refreshView.refreshDataBlock=^(int page)
    {
        [tempView getDataWithPage:0 pageSize:page*PageSize];
    };
    [self.view addSubview:self.refreshView.view];
    [self addChildViewController:self.refreshView];

}


#pragma mark - 数据刷新相关方法
// 按页码查询数据
-(void)getDataWithPage:(int)page pageSize:(int)pageSize
{
    self.data=[[CoreDataManager Instance]selectDataWithFetchedResult:pageSize
                                                           andOffset:page
                                                             sortKey:@"vid"
                                                           ascending:YES
                                                          entityName:@"VideoRow"];
    [self.data performFetch:nil];
}

#pragma mark - UITableView 委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo=[self.data.sections objectAtIndex:0];
    NSInteger rowCount=[sectionInfo numberOfObjects];
    return rowCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"NewsCell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    VideoRow * videoRow=[self.data objectAtIndexPath:indexPath];
    cell.textLabel.text=videoRow.content;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

#pragma mark UIScrollViewDelegate Methods 委托
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[self.refreshView relateScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"ScrollEnd");
    [self.refreshView relateScrollEnd];
}

@end
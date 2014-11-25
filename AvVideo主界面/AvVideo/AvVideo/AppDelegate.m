//
//  AppDelegate.m
//  GeneralFramework
//
//  Created by user on 14-8-5.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "HotViewController.h"
#import "MessageViewController.h"
#import "VideoViewController.h"
#import "AccountViewController.h"
#import "VideoRow.h"
#import "CoreDataManager.h"
#import "UISDK.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    self.window.rootViewController=[self getRootViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self requestDataAndInsert];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 自定义方法
/// 请求并插入数据到数据库
-(void)requestDataAndInsert
{
    for(int i=0;i<20;i++)
    {
        VideoRow * videoRow=[[CoreDataManager Instance]insertCoreDataWithEntityName:@"VideoRow"];
        NSNumber * value=[NSNumber numberWithInt:i];
        videoRow.vid=value;
        videoRow.content=@"Test";
    }
    [[CoreDataManager Instance]saveData];
}

/// 设置视图控件
-(UIViewController *)getRootViewController
{
    UITabBarController * tabController=[[UITabBarController alloc]init];
    
    // 设置主页面
    MainViewController * mainViewController=[[MainViewController alloc]
                                             init];
    UINavigationController * mainNav=[[UINavigationController alloc]
                                      initWithRootViewController:mainViewController];
    UIImage * mainImg=[[UISDK Instance]getImg:@"tab_feed.png"];
    UITabBarItem * mainItem=[[UITabBarItem alloc]initWithTitle:@"首页" image:mainImg tag:1];
    mainNav.tabBarItem=mainItem;
    // 设置热门页面
    HotViewController *  hotController=[[HotViewController alloc]init];
    UINavigationController * hotNav=[[UINavigationController alloc]
                                     initWithRootViewController:hotController];
    UIImage * hotImg=[[UISDK Instance]getImg:@"tab_live.png"];
    UITabBarItem * hotItem=[[UITabBarItem alloc]initWithTitle:@"Hot" image:hotImg tag:2];
    hotNav.tabBarItem=hotItem;
    
    // 设置视频页面
    UIImage * img=[[UISDK Instance]getImg:@"camera_button_take.png"];
    UIImage * slImg=[[UISDK Instance]getImg:@"tabBar_cameraButton_ready_matte.png"];
    CGRect rect=CGRectMake(0, 0, img.size.width, img.size.height);
    UIViewController * emptyController=[[UIViewController alloc]init];
    UIButton * centerBut=[[UISDK Instance]addButton:rect
                                              title:nil
                                              color:nil
                                             hcolor:nil
                                               font:nil
                                              bgImg:img
                                             selImg:slImg
                                              block:^(UIButton *but) {
                                                  VideoViewController * videoView=[[VideoViewController alloc]
                                                                                   init];
                                                  UINavigationController * videoNav=[[UINavigationController alloc]initWithRootViewController:videoView];
                                                  
                                                  [tabController presentModalViewController:videoNav
                                                                                   animated:YES];
                                              }
                                               view:tabController.view];
    centerBut.center=CGPointMake(ScreenWidth/2, ScreenHeight-33);
    // 设置消息页面
    MessageViewController * messageController=[[MessageViewController alloc]init];
    UINavigationController * messageNav=[[UINavigationController alloc]initWithRootViewController:messageController];
    UIImage * messageImg=[[UISDK Instance]getImg:@"tab_messages.png"];
    UITabBarItem * messageItem=[[UITabBarItem alloc]initWithTitle:@"Message" image:messageImg tag:4];
    messageNav.tabBarItem=messageItem;
    
    // 设置账户页面
    AccountViewController * accountController=[[AccountViewController alloc]init];
    UINavigationController * accountNav=[[UINavigationController alloc]initWithRootViewController:accountController];
    UIImage * accountImg=[[UISDK Instance]getImg:@"tab_feed_profile.png"];
    UITabBarItem * accountItem=[[UITabBarItem alloc]initWithTitle:@"Account" image:accountImg tag:5];
    accountNav.tabBarItem=accountItem;
    
    tabController.viewControllers=[NSArray arrayWithObjects:mainNav,
                                                            hotNav,
                                                            emptyController,
                                                            messageNav,
                                                            accountNav,
                                                            nil];
    return tabController;
}
@end

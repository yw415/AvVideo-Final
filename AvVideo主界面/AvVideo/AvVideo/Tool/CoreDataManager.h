//
//  CoreDataManager.h
//  CoreDataTest
//
//  Created by user on 14-8-4.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject
/// 实例方法
+(CoreDataManager *)Instance;
// 保存数据
-(void)saveData;
/// 插入数据
-(id)insertCoreDataWithEntityName:(NSString *)entityName;
/// 查询数据
-(NSMutableArray *)selectData:(int)pageSize
                    andOffset:(int)currentPage
                   entityName:(NSString *)entityName;
///条件查询
-(NSMutableArray *)selectData:(int)pageSize
                    andOffset:(int)currentPage
                   entityName:(NSString *)entityName
                        where:(NSString *)where;

/// 查询数据返回NSFetchedResultsController
-(NSFetchedResultsController *)selectDataWithFetchedResult:(int)pageSize
                                                 andOffset:(int)currentPage
                                                   sortKey:(NSString *)key
                                                 ascending:(BOOL)ascending
                                                entityName:(NSString *)entityName;

/// 条件查询返回NSFetchedResultsController
-(NSFetchedResultsController *)selectDataWithFetchedResult:(int)pageSize
                                                 andOffset:(int)currentPage
                                                   sortKey:(NSString *)key
                                                 ascending:(BOOL)ascending
                                                entityName:(NSString *)entityName
                                                     where:(NSString *)where;

/// 删除数据
-(void)removeData:(id)entity;
@end

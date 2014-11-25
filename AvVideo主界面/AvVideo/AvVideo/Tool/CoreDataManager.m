//
//  CoreDataManager.m
//  CoreDataTest
//
//  Created by user on 14-8-4.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "CoreDataManager.h"
#define DataBaseName @"DataBase.sqlite"
#define ModelName @"DataBase"
@interface CoreDataManager()
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong)NSManagedObjectModel * managedObjectModel;
@property(nonatomic,strong)NSPersistentStoreCoordinator * persistentStoreCoordinator;
@end

@implementation CoreDataManager
/// 初始化
-(id)init
{
    self=[super init];
    if(self)
    {
        
    }
    return self;
}

/// 单例
+(CoreDataManager *)Instance
{
    static CoreDataManager * instance=nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    
    return instance;
}

/// 初始化NSManagedObjectContext
-(NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext!=nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator * coordinator=[self persistentStoreCoordinator];
    if(coordinator!=nil)
    {
        _managedObjectContext=[[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

/// 初始化NSPersistentStoreCoordinator
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator!=nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL * path=[[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask]lastObject];
    
    path=[path URLByAppendingPathComponent:DataBaseName];
    
    NSError * error=nil;
    NSManagedObjectModel * model=[self managedObjectModel];
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:path
                                                            options:nil
                                                              error:&error];
    return _persistentStoreCoordinator;
    
}

/// 初始化NSManagedObjectModel
-(NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel!=nil)
    {
        return _managedObjectModel;
    }
    
    NSURL * modelURL=[[NSBundle mainBundle]URLForResource:ModelName withExtension:@"momd"];
    _managedObjectModel=[[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/// 保存数据
-(void)saveData
{
    NSError * error=nil;
    NSManagedObjectContext * managedObjectContext=self.managedObjectContext;
    if(managedObjectContext!=nil)
    {
        if([managedObjectContext hasChanges]&&![managedObjectContext save:&error])
        {
            NSLog(@"\n保存数据失败\n");
        }
    }
}

/// 插入数据
-(id)insertCoreDataWithEntityName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:self.managedObjectContext];
}

/// 查询数据
-(NSMutableArray *)selectData:(int)pageSize
                    andOffset:(int)currentPage
                   entityName:(NSString *)entityName;
{
    NSManagedObjectContext * context=[self managedObjectContext];
    
    NSFetchRequest * fetchRequest=[[NSFetchRequest alloc]init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    
    NSEntityDescription * entity=[NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError * error;
    NSArray * fetchedObjects=[context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray * resultArray=[NSMutableArray arrayWithArray:fetchedObjects];
    
    return resultArray;
}
/// 条件查询
-(NSMutableArray *)selectData:(int)pageSize
                    andOffset:(int)currentPage
                   entityName:(NSString *)entityName
                        where:(NSString *)where
{
    NSManagedObjectContext * context=[self managedObjectContext];
    
    NSPredicate * predicate=[NSPredicate predicateWithFormat:where];
    
    NSFetchRequest * fetchRequest=[[NSFetchRequest alloc]init];
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    [fetchRequest setPredicate:predicate];
    
    NSEntityDescription * entity=[NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError * error;
    NSArray * fetchedObjects=[context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray * resultArray=[NSMutableArray arrayWithArray:fetchedObjects];
    
    return resultArray;
}

/// 查询数据返回NSFetchedResultsController
-(NSFetchedResultsController *)selectDataWithFetchedResult:(int)pageSize
                                                 andOffset:(int)currentPage
                                                   sortKey:(NSString *)key
                                                 ascending:(BOOL)ascending
                                                entityName:(NSString *)entityName;
{
    NSManagedObjectContext * context=[self managedObjectContext];
    
    NSSortDescriptor * sort=[[NSSortDescriptor alloc]initWithKey:key ascending:ascending];
    NSArray * sortArray=[[NSArray alloc]initWithObjects:sort, nil];
    
    NSEntityDescription * entity=[NSEntityDescription entityForName:entityName
                                             inManagedObjectContext:context];
    
    NSFetchRequest * fetchRequest=[[NSFetchRequest alloc]init];
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    [fetchRequest setSortDescriptors:sortArray];
    [fetchRequest setEntity:entity];
    
    NSFetchedResultsController * fetchedResultController=
    [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    
    
    
    return fetchedResultController;
}

/// 条件查询返回NSFetchedResultsController
-(NSFetchedResultsController *)selectDataWithFetchedResult:(int)pageSize
                                                 andOffset:(int)currentPage
                                                   sortKey:(NSString *)key
                                                 ascending:(BOOL)ascending
                                                entityName:(NSString *)entityName
                                                     where:(NSString *)where
{
    return nil;
}

/// 删除数据
-(void)removeData:(id)entity
{
    NSManagedObjectContext * context=[self managedObjectContext];
    [context deleteObject:entity];
}
@end

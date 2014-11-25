//
//  VideoRow.h
//  AvVideo
//
//  Created by user on 14-11-21.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VideoRow : NSManagedObject

@property (nonatomic, retain) NSNumber * vid;
@property (nonatomic, retain) NSString * content;

@end

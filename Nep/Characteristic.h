//
//  Characteristic.h
//  Nep
//
//  Created by Justin Farlow on 3/12/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Dataset;

@interface Characteristic : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * locX;
@property (nonatomic, retain) NSNumber * locY;
@property (nonatomic, retain) NSString * misc;
@property (nonatomic, retain) NSNumber * validated;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Dataset *dataset;

@end

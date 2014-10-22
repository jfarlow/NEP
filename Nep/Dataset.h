//
//  Dataset.h
//  Nep
//
//  Created by Justin Farlow on 3/28/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Characteristic, Slice;

@interface Dataset : NSManagedObject

@property (nonatomic, retain) NSString * condition;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * updated;
@property (nonatomic, retain) NSString * moviepath;
@property (nonatomic, retain) NSSet *characteristics;
@property (nonatomic, retain) NSSet *slices;
@property (nonatomic, retain) NSMutableDictionary *totals;
@end

@interface Dataset (CoreDataGeneratedAccessors)

- (void)addCharacteristicsObject:(Characteristic *)value;
- (void)removeCharacteristicsObject:(Characteristic *)value;
- (void)addCharacteristics:(NSSet *)values;
- (void)removeCharacteristics:(NSSet *)values;

- (void)addSlicesObject:(Slice *)value;
- (void)removeSlicesObject:(Slice *)value;
- (void)addSlices:(NSSet *)values;
- (void)removeSlices:(NSSet *)values;

@end

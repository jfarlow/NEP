//
//  Slice.h
//  Nep
//
//  Created by Justin Farlow on 3/12/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Characteristic, Dataset;

@interface Slice : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSSet *characteristcs;
@property (nonatomic, retain) Dataset *dataset;
@end

@interface Slice (CoreDataGeneratedAccessors)

- (void)addCharacteristcsObject:(Characteristic *)value;
- (void)removeCharacteristcsObject:(Characteristic *)value;
- (void)addCharacteristcs:(NSSet *)values;
- (void)removeCharacteristcs:(NSSet *)values;

@end

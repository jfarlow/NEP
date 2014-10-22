//
//  Category.h
//  Nep
//
//  Created by Justin Farlow on 3/12/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Characteristic;

@interface Category : NSManagedObject

@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *characteristics;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addCharacteristicsObject:(Characteristic *)value;
- (void)removeCharacteristicsObject:(Characteristic *)value;
- (void)addCharacteristics:(NSSet *)values;
- (void)removeCharacteristics:(NSSet *)values;

@end

//
//  Dataset.m
//  Nep
//
//  Created by Justin Farlow on 3/28/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import "Dataset.h"
#import "Document.h"
#import "Characteristic.h"
#import "Category.h"
#import "Slice.h"


@implementation Dataset

@dynamic condition;
@dynamic name;
@dynamic path;
@dynamic summary;
@dynamic updated;
@dynamic moviepath;
@dynamic characteristics;
@dynamic slices;
@dynamic totals;


-(NSMutableDictionary *)totals{
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSArray *allCats = [myDoc.CategoryControllerOutlet arrangedObjects];
    NSArray *allChars = [[self characteristics] allObjects];
    
    for (Category *eachCat in allCats) {
        NSString *catName = eachCat.name;
        NSPredicate *catPredicate = [NSPredicate predicateWithFormat:@"category.name==%@",catName];
        NSArray *thoseChars = [allChars filteredArrayUsingPredicate:catPredicate];
        NSNumber *thoseCharCount = [NSNumber numberWithInteger:thoseChars.count];
        [newDict setObject:thoseCharCount forKey:catName];
    }
    
    //[self setUpdated:[NSNumber numberWithBool:YES]];
    return newDict;
}


+(NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"totals"]) {
        NSArray *affectingKeys = @[@"characteristics",@"updated"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    if ([key isEqualToString:@"path"] || [key isEqualToString:@"name"]) {

        
        
    }
    
    return keyPaths;
    
    
}

@end

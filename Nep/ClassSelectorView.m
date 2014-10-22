//
//  ClassSelectorView.m
//  Nep
//
//  Created by Justin Farlow on 3/12/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import "ClassSelectorView.h"
#import "Document.h"
#import "Category.h"
#import "Dataset.h"
#import "Characteristic.h"
#import "Slice.h"

@implementation ClassSelectorView

@synthesize carriedPoint;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (BOOL)acceptsFirstResponder{
    return NO;
}


- (void)keyDown:(NSEvent *)theEvent{
    NSInteger pressed = [theEvent keyCode];
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    if (pressed >= 18 && pressed <= 28) { //toprow keypress
        NSArray *myCats = [myDoc.CategoryControllerOutlet arrangedObjects];
        NSInteger myCatCount = myCats.count;
        if (pressed == 18 && myCatCount > 0) {
            [myDoc.CategoryControllerOutlet setSelectionIndex:0];
        }else if (pressed == 19 && myCatCount > 1){
            [myDoc.CategoryControllerOutlet setSelectionIndex:1];
        }else if (pressed == 20 && myCatCount > 2){
            [myDoc.CategoryControllerOutlet setSelectionIndex:2];
        }else if (pressed == 21 && myCatCount > 3){
            [myDoc.CategoryControllerOutlet setSelectionIndex:3];
        }else if (pressed == 23 && myCatCount > 4){
            [myDoc.CategoryControllerOutlet setSelectionIndex:4];
        }else if (pressed == 22 && myCatCount > 5){
            [myDoc.CategoryControllerOutlet setSelectionIndex:5];
        }else if (pressed == 26 && myCatCount > 6){
            [myDoc.CategoryControllerOutlet setSelectionIndex:6];
        }else if (pressed == 28 && myCatCount > 7){
            [myDoc.CategoryControllerOutlet setSelectionIndex:7];
        }else if (pressed == 25 && myCatCount > 8){
            [myDoc.CategoryControllerOutlet setSelectionIndex:8];
        }else if (pressed == 29 && myCatCount > 9){
            [myDoc.CategoryControllerOutlet setSelectionIndex:9];
        }
        
        Dataset *myData = [[myDoc.DatasetControllerOutlet selectedObjects] objectAtIndex:0];
        Category *myCat = [[myDoc.CategoryControllerOutlet selectedObjects] objectAtIndex:0];
        Slice *mySlice = [[myDoc.SliceControllerOutlet selectedObjects] objectAtIndex:0];
        //Characteristic *newChar = [myDoc.CharacteristicControllerOutlet newObject];
        Characteristic *newChar = [myDoc.CharacteristicControllerOutlet newObject];
        newChar.locX = [NSNumber numberWithFloat:carriedPoint.x];
        newChar.locY = [NSNumber numberWithFloat:carriedPoint.y];
        newChar.validated = [NSNumber numberWithBool:YES];
        newChar.index = mySlice.index;
        
        [newChar setDataset:myData];
        [newChar setCategory:myCat];
//        [myDoc.CharacteristicControllerOutlet addObject:newChar];
        myData.updated = [NSNumber numberWithInteger:1];
        
        
    }
    AppDelegate *myDelegate = [myDoc TheAppDelegate];
    [[myDelegate SelectCharPopover] close];
    
    
    
    /*
    
    [[myDelegate SelectCharPopover] close];
    [myDoc.ImageCanvasOutlet setNeedsDisplay];
    [myDoc.MovieCanvasOutlet setNeedsDisplay:YES];
    [myDoc.MovieCanvasOutlet setNeedsDisplay];
*/
}

@end

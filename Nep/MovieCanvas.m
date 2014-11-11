//
//  MovieCanvas.m
//  Nep
//
//  Created by Justin Farlow on 3/28/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//


#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MovieCanvas.h"
#import "Document.h"
#import "Dataset.h"
#import "Category.h"
#import "Characteristic.h"




@implementation MovieCanvas

@synthesize moviePlayer;
@synthesize movieURL;
@synthesize movieURLString;



/*-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    
    if ([keyPath  isEqual: @"selection"]) {
        
        if (object != nil) {
            [self initPlayerWithCurrentData];
            
            
        }
    }
}*/



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
    
    movieURL = [NSURL URLWithString:movieURLString];
    [self initPlayerWithURL:movieURL];
    
    
    /*
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSArray *docData = [myDoc.DatasetControllerOutlet selectedObjects];
    if (docData.count>0) {
        Dataset *myData = [docData objectAtIndex:0];
        
        NSArray *characteristics = [myData.characteristics allObjects];
        
        for (Characteristic *eachChar in characteristics) {
            NSColor *theColor = eachChar.category.color;
            [theColor set];
            
            NSInteger radius = myDoc.featureDiamter;
            NSRect rect = NSMakeRect([eachChar.locX floatValue] - radius,  [eachChar.locY floatValue] - radius, radius * 2, radius * 2);
            NSBezierPath* circlePath = [NSBezierPath bezierPath];
            [circlePath appendBezierPathWithOvalInRect: rect];
            [circlePath setLineWidth:2];
            [circlePath stroke];
            
        }
        NSArray *selectedChars = [myDoc.CharacteristicControllerOutlet selectedObjects];
        for (Characteristic *eachChar in selectedChars) {
            NSColor *theColor = [NSColor redColor];
            [theColor set];
            
            NSInteger radius = myDoc.featureDiamter + 4;
            NSRect rect = NSMakeRect([eachChar.locX floatValue] - radius,  [eachChar.locY floatValue] - radius, radius * 2, radius * 2);
            NSBezierPath* circlePath = [NSBezierPath bezierPath];
            [circlePath appendBezierPathWithOvalInRect: rect];
            [circlePath setLineWidth:2];
            [circlePath stroke];
            
        }
    }
    
    
    */
    
    // Drawing code here.
    
    
}

/*
-(void)setNeedsDisplay{
    [self drawRect:NSZeroRect];
}
*/


/*
-(void)mouseUp:(NSEvent *)theEvent{
   
    
 
     NSPoint mouseRawPoint = [theEvent locationInWindow];
    NSPoint mousePoint = [self convertPoint: mouseRawPoint fromView: nil];
    
    
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    
    NSInteger cats = [[myDoc.CategoryControllerOutlet arrangedObjects] count] + 1;
    if (cats==1) {
        [myDoc PopulateCategories:self];
    }
    NSInteger height = (16 * cats) + (cats) + 1;
    NSRect selectRect = NSMakeRect(mouseRawPoint.x + 200, mouseRawPoint.y + 200, 220, height);
    ClassSelectorView *selectView = myDoc.ClassificationSelectionViewerOutlet;
    NSWindow *selectWindow = [selectView window];
    [selectView setCarriedPoint:mousePoint];
    [selectWindow setFrame:selectRect display:YES animate:NSWindowAnimationBehaviorAlertPanel];
    [selectWindow makeKeyAndOrderFront:self];
 
    
}
*/


-(void)initPlayerWithCurrentData{
    
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSArray *selectedObs = [myDoc.DatasetControllerOutlet selectedObjects];
    if ([selectedObs count] > 0) {
        Dataset *myDataset = [selectedObs objectAtIndex:0];
        [self setMovieURL:[NSURL URLWithString:myDataset.moviepath]];
        moviePlayer = [AVPlayer playerWithURL:movieURL];
        
        moviePlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[moviePlayer currentItem]];
        
        
        [self setPlayer:moviePlayer];

        
        /*if ([moviePlayer status] == AVPlayerStatusReadyToPlay) {
            [self setPlayer:moviePlayer];
            [myDoc.ErrorOutlet setStringValue:@""];
        }else{
            [myDoc.ErrorOutlet setStringValue:@"Error loading file"];
        }
    */
    }
    
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
        Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    
    
    
    AVPlayerItem *p = [notification object];
    
    int32_t timeScale = p.duration.timescale;
    CMTime oldTime = p.duration;
    oldTime.value = 0.0;
    
    [p seekToTime:oldTime   ];
    [[myDoc.MovieCanvasOutlet player] pause];
    
}

-(void)initPlayerWithURL:(NSURL*)inputURL{
        Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    moviePlayer = [AVPlayer playerWithURL:inputURL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[moviePlayer currentItem]];
    
    /*if ([moviePlayer status] == AVPlayerStatusReadyToPlay) {
        [self setPlayer:moviePlayer];
        [myDoc.ErrorOutlet setStringValue:@""];
    }else{
        [myDoc.ErrorOutlet setStringValue:@"Error loading file"];
    }*/
    [self setPlayer:moviePlayer];
}


@end


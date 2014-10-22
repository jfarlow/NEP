//
//  Document.m
//  Nep
//
//  Created by Justin Farlow on 3/11/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Document.h"
#import "AppDelegate.h"
#import "Category.h"
#import "Characteristic.h"
#import "Dataset.h"
#import "Slice.h"
#import "MovieCanvas.h"

@implementation Document

//delegates
@synthesize TheAppDelegate;

//controllers
@synthesize CategoryControllerOutlet;
@synthesize CharacteristicControllerOutlet;
@synthesize DatasetControllerOutlet;
@synthesize SliceControllerOutlet;



///Other Views
@synthesize ClassificationSelectionViewerOutlet;
@synthesize ClassSelectionViewer;

///Main Doc.xib Objects
@synthesize ImageScrollerOutlet;
@synthesize ColorSelectorOutlet;
@synthesize ImageCanvasOutlet;
@synthesize TotalsTableOutlet;
@synthesize AllDataTotalDictionaryOutlet;
@synthesize MovieCanvasOutlet;
@synthesize ErrorOutlet;

///timers
@synthesize isPlaying;
@synthesize _timer;
@synthesize timerInterval;

///prefs
@synthesize featureDiamter;



- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.

    
    
   // NSManagedObjectContext *context= TheAppDelegate.managedObjectContext;
    //[self setManagedObjectContext:context];
    NSManagedObjectContext *context= [self managedObjectContext];
    ///set MOCs - requried for save!!!!
    [DatasetControllerOutlet setManagedObjectContext:context];
    [CategoryControllerOutlet setManagedObjectContext:context];
    [SliceControllerOutlet setManagedObjectContext:context];
    [CharacteristicControllerOutlet setManagedObjectContext:context];
    
    ///Set Sort Descriptors
    NSSortDescriptor* sortByIndex = [[NSSortDescriptor alloc] initWithKey: @"index" ascending: YES];
    [SliceControllerOutlet setSortDescriptors:[NSArray arrayWithObjects:sortByIndex, nil]];
    NSSortDescriptor* sortByName = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
    [CategoryControllerOutlet setSortDescriptors:@[sortByName]];
    
    timerInterval = 10;
    featureDiamter = 10;
    
    
    [DatasetControllerOutlet addObserver:MovieCanvasOutlet forKeyPath:@"selection" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    [DatasetControllerOutlet addObserver:MovieCanvasOutlet forKeyPath:@"selection" options:NSKeyValueObservingOptionNew context:NULL];
    
    

    
    
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (IBAction)GetImageStack:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    [panel setPrompt:@"Select"];
    if ([panel runModal]) { //panel selection occured
        NSArray *fileURLs = [panel URLs];
        
        Dataset *newData = [DatasetControllerOutlet newObject];
        newData.name = @"new dataset";
        [DatasetControllerOutlet addObject:newData];
        
        [SliceControllerOutlet removeObjects:[SliceControllerOutlet arrangedObjects]];
        NSArray *theImageURLS = [[NSArray alloc] init];
        NSInteger urlCount = [fileURLs count];
        if (urlCount == 1) {
            NSURL *folderPath = [fileURLs objectAtIndex:0];
            newData.path = [folderPath absoluteString];
            NSArray *imageNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[folderPath path] error:nil];
            
            for (NSString *eachImageName in imageNames) {
                if ([eachImageName characterAtIndex:0] != '.' ) {
                    
                    NSString *folderPathString = [folderPath absoluteString];
                    NSString *filePathString = [NSString stringWithFormat:@"%@%@",folderPathString,eachImageName];
                    NSString *filePathEscapedString = [filePathString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSURL *eachImageU = [NSURL URLWithString:eachImageName relativeToURL:folderPath];
                    
                    NSURL *eachImageURL = [NSURL URLWithString:filePathEscapedString];
                    theImageURLS = [theImageURLS arrayByAddingObject:eachImageURL];
                }
            }
            
            
        }else if(urlCount > 1){
            NSURL *firstURL = [fileURLs objectAtIndex:0];
            newData.path = [[firstURL URLByDeletingLastPathComponent] path];
            theImageURLS = fileURLs;
        }
        
        /////All images located within theImageURLS;
        //Parse all image paths into new Slices:
        
        
        for (int i=0; i<theImageURLS.count; i++){
            NSURL *eachImageURL = [theImageURLS objectAtIndex:i];
            Slice *newSlice = [SliceControllerOutlet newObject];
            newSlice.path = [eachImageURL absoluteString];
            newSlice.index = [NSNumber numberWithInt: i];
            [newSlice setDataset:newData];
        }

    }
    
    
    
}

- (IBAction)GetMovie:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    [panel setPrompt:@"Select"];
    if ([panel runModal]) { //panel selection occured
        NSArray *fileURLs = [panel URLs];
        
        NSString *theFolder = [[NSString alloc] init];
        
        //[SliceControllerOutlet removeObjects:[SliceControllerOutlet arrangedObjects]];
        NSArray *theImageURLS = [[NSArray alloc] init];
        NSInteger urlCount = [fileURLs count];
        /*if (urlCount == 1) {
            NSURL *folderPath = [fileURLs objectAtIndex:0];
            theFolder = [folderPath absoluteString];
            NSArray *imageNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[folderPath path] error:nil];
            
            for (NSString *eachImageName in imageNames) {
                if ([eachImageName characterAtIndex:0] != '.' ) {
                    
                    NSString *folderPathString = [folderPath absoluteString];
                    NSString *filePathString = [NSString stringWithFormat:@"%@%@",folderPathString,eachImageName];
                    NSString *filePathEscapedString = [filePathString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    //NSURL *eachImageURL = [NSURL URLWithString:eachImageName relativeToURL:folderPath];
                    
                    NSURL *eachImageURL = [NSURL URLWithString:filePathEscapedString];
                    theImageURLS = [theImageURLS arrayByAddingObject:eachImageURL];
                }
            }*/
        
        
        if (urlCount == 1) {
            NSURL *firstURL = [fileURLs objectAtIndex:0];
            theFolder = [[firstURL URLByDeletingLastPathComponent] path];
            theImageURLS = fileURLs;
            
            
        }else if(urlCount > 1){
            NSURL *firstURL = [fileURLs objectAtIndex:0];
            theFolder = [[firstURL URLByDeletingLastPathComponent] path];
            theImageURLS = fileURLs;
        }
        
        /////All images located within theImageURLS;
        //Parse all image paths into new Slices:
        
        
        
        
        for (int i=0; i<theImageURLS.count; i++){
            NSURL *eachURL = [theImageURLS objectAtIndex:i];
            Dataset *newData = [DatasetControllerOutlet newObject];
            Slice *singleslice = [SliceControllerOutlet newObject];
            newData.name = [eachURL lastPathComponent];
            newData.path = theFolder;
            newData.moviepath = [eachURL absoluteString];
            [newData addSlicesObject:singleslice];
            
            [DatasetControllerOutlet addObject:newData];
            
        }
        
        
        
        
        
    }
    
    
    
    
    Dataset *myData=  [[DatasetControllerOutlet selectedObjects] objectAtIndex:0];
    NSURL *movieURL =[NSURL URLWithString:myData.moviepath];
    
//    AVPlayer *playerItem = [AVPlayer playerWithURL:movieURL];
    
    [MovieCanvasOutlet initPlayerWithURL:movieURL];
    
/*
    
    if ([playerItem status] == AVPlayerStatusReadyToPlay) {
        [MovieCanvasOutlet setPlayer:playerItem];
        [ErrorOutlet setStringValue:@""];
    }else{
        [ErrorOutlet setStringValue:@"Error loading file"];
    }
    */
    
}

- (IBAction)ExportData:(id)sender {
    NSArray *allData = [DatasetControllerOutlet arrangedObjects];
    NSDictionary *allTotals = [AllDataTotalDictionaryOutlet content];
    
    NSArray *allCounts = [allTotals allValues];
    NSInteger sumTotal = [[allCounts valueForKeyPath:@"@sum.self"] integerValue];
    
    NSString *outputData = [NSString stringWithFormat:@"Of %ld total counted objects:\rCondition\tTotal (#)\tPercent (%%)\r",(long)sumTotal];
    for (NSString *eachKey in [allTotals allKeys]) {
        NSString *eachValue = [allTotals valueForKey:eachKey];
        NSInteger percentI = roundf((100 * [eachValue integerValue]) / sumTotal);
        NSString *percent = [NSString stringWithFormat:@"%li",percentI];
        outputData = [outputData stringByAppendingFormat:@"%@:\t%@\t%@\r",
                      eachKey,
                      percent,
                      eachValue];
    }
    outputData = [outputData stringByAppendingString:@"\r\r"];
    
    
    
    NSString *conditionName = @"";
    for (Dataset *eachData in allData) {
        NSMutableDictionary *totals = eachData.totals;
        NSArray *keys = [totals allKeys];
        
        NSString *outputCats = @"";
        for (NSString *eachKey in keys) {
            NSString *counts = [totals valueForKey:eachKey];
            outputCats = [outputCats stringByAppendingFormat:@"%@\t%@\t",
                          eachKey,
                          counts];
        }
        
        outputData = [outputData stringByAppendingFormat:@"%@\t%@%@\t%@\t%@\r",
                      eachData.name,
                      outputCats,
                      eachData.condition,
                      eachData.summary,
                      eachData.path];
        
        
        
        if (![eachData.condition isEqualToString:@""]) {
            conditionName = [NSString stringWithFormat:@" - %@", eachData.condition];
        }
    }
    
    
    NSString *filename = [NSString stringWithFormat:@"NEP Counts%@",conditionName];
    [self ExportToFile:outputData withName:filename];

    
    
}
- (IBAction)SelectColorsToShow:(id)sender {

}
- (IBAction)CategoryForPointSelected:(id)sender {
    Dataset *myData = [[DatasetControllerOutlet selectedObjects] objectAtIndex:0];
    Category *myCat = [[CategoryControllerOutlet selectedObjects] objectAtIndex:0];
    Characteristic *newChar = [CharacteristicControllerOutlet newObject];
    newChar.locX = [NSNumber numberWithFloat:ClassSelectionViewer.carriedPoint.x];
    newChar.locY = [NSNumber numberWithFloat:ClassSelectionViewer.carriedPoint.y];
    newChar.validated = [NSNumber numberWithBool:YES];
    
    
    [newChar setDataset:myData];
    [newChar setCategory:myCat];
    
    
    
    [[TheAppDelegate SelectCharPopover] close];
    
    [ImageCanvasOutlet setNeedsDisplay];
    
    NSDictionary *theCounts = myData.totals;
}



- (IBAction)PlayTimer:(id)sender {
    
    if (!isPlaying) {
        _timer  = [NSTimer scheduledTimerWithTimeInterval:(1/timerInterval) target:self selector:@selector(OnPlay) userInfo:Nil repeats:YES];
        isPlaying = YES;
    }else{
        isPlaying = NO;
        [_timer  invalidate];
        
    }
}


- (void)OnPlay{
    NSInteger currentSelect = [SliceControllerOutlet selectionIndex];
    if (currentSelect < ([[SliceControllerOutlet arrangedObjects] count] - 1)) {
        [SliceControllerOutlet setSelectionIndex:(currentSelect + 1)];
    }else{
        [SliceControllerOutlet setSelectionIndex:0];
    }
}

- (IBAction)FeatureSelectionChanged:(id)sender {
    [ImageCanvasOutlet setNeedsDisplay];
    [MovieCanvasOutlet setHidden:YES];
    [ImageCanvasOutlet setNeedsDisplay];

}

- (IBAction)DataSelectionChanged:(id)sender {
    Dataset *myData = [[DatasetControllerOutlet selectedObjects] objectAtIndex:0];
    NSURL *dataURL = [NSURL URLWithString:myData.moviepath];
    [MovieCanvasOutlet initPlayerWithURL:dataURL];
    [MovieCanvasOutlet setHidden:NO];
}

- (IBAction)PopulateCategories:(id)sender {
    
    
    
     Category *cat1 = [CategoryControllerOutlet newObject];
     cat1.name = @"Normal";
     cat1.color = [NSColor blackColor];
     Category *cat2 = [CategoryControllerOutlet newObject];
     cat2.name = @"Extruder";
     cat2.color = [NSColor redColor];
     Category *cat3 = [CategoryControllerOutlet newObject];
     cat3.name = @"Protruder";
     cat3.color = [NSColor blueColor];
     Category *cat4 = [CategoryControllerOutlet newObject];
     cat4.name = @"Runner";
     cat4.color = [NSColor greenColor];
     
     [CategoryControllerOutlet addObjects:[NSArray arrayWithObjects:cat2,cat1,cat3,cat4, nil]];
    

}

- (IBAction)ChangeMovieVisability:(id)sender {
    NSInteger isHidden = [sender integerValue];
    if (isHidden) {
        [MovieCanvasOutlet setHidden:NO];
    }else{
        [MovieCanvasOutlet setHidden:YES];
    }
    [ImageCanvasOutlet setFrame:[MovieCanvasOutlet frame]];
    
}

- (IBAction)ChangeMovieControlls:(id)sender {
    NSPopUpButton *control = sender;
    NSInteger i = [control indexOfSelectedItem];
    
    
    if (i == 0) {
        [MovieCanvasOutlet setControlsStyle:AVPlayerViewControlsStyleDefault];
    }else if(i == 1){
        [MovieCanvasOutlet setControlsStyle:AVPlayerViewControlsStyleFloating];
    }else if(i == 2){
        [MovieCanvasOutlet setControlsStyle:AVPlayerViewControlsStyleInline];
    }else if(i == 3){
        [MovieCanvasOutlet setControlsStyle:AVPlayerViewControlsStyleMinimal];
    }
    
}

- (IBAction)PlayMovie:(id)sender {
    NSButton *button = sender;
    
    float playing = [[MovieCanvasOutlet player] rate];
    
    if (playing > 0 && [[MovieCanvasOutlet player] status] == AVPlayerStatusReadyToPlay) {
        [[MovieCanvasOutlet player] pause];
        [button setImage:[NSImage imageNamed:@"NSGoRightTemplate"]];
        
    }else if (playing <= 0 && [[MovieCanvasOutlet player] status] == AVPlayerStatusReadyToPlay){
        [[MovieCanvasOutlet player] play];
        [button setImage:[NSImage imageNamed:@"NSStopProgressTemplate"]];
    }
}

- (IBAction)ResetMovie:(id)sender {
    AVPlayerItem *player = [[MovieCanvasOutlet player] currentItem];

    CMTime oldTime = player.duration;
    oldTime.value = 0.0;
    
    [player seekToTime:oldTime   ];
    
}

-(void)ExportToFile:(NSString *)data withName:(NSString *)docName{
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:docName];
    NSInteger ret = [panel runModal];
    if (ret == NSFileHandlingPanelOKButton) {
        NSURL *fileURL = [[panel URL] URLByAppendingPathExtension:@"csv"];
        [data writeToURL:fileURL atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
}




@end



@implementation EachFromArray
- (id)transformedValue:(id)value{
    
    return value;
}
@end

@implementation Decrimented
- (id)transformedValue:(id)value{
    NSInteger intVal = [value integerValue];
    return [NSNumber numberWithInteger:(intVal -1)];
}
@end
@implementation Incremented
- (id)transformedValue:(id)value{
    NSInteger intVal = [value integerValue];
    return [NSNumber numberWithInteger:(intVal +1)];
}
@end
@implementation IsNotOne
- (id)transformedValue:(id)value{
    NSInteger intVal = [value integerValue];
    if (intVal == 1) {
        return [NSNumber numberWithBool:NO];
    }else{
        return [NSNumber numberWithBool:YES];
    }
}
@end
@implementation Totaled
- (id)transformedValue:(id)value{
    
    
    NSMutableDictionary *combinedDictionary = [[NSMutableDictionary alloc] init];
    
    
    
    
    if ([value count] > 0) {
       
        
        for (NSDictionary *currentDictionary in value) {
            for (NSString *key in [currentDictionary allKeys]) {

                NSInteger thisValue = [[currentDictionary valueForKey:key] integerValue];
                NSInteger currentTotalValue = [[combinedDictionary valueForKey:key] integerValue];
                NSInteger newValue = thisValue;
                if (currentTotalValue) {
                    newValue = thisValue + currentTotalValue;
                }

                [combinedDictionary setValue:[NSNumber numberWithInteger:newValue] forKey:key];
            }
        }
        return combinedDictionary;
    }else{
        return combinedDictionary;
    }
    
}
@end
@implementation PercentTotal
- (id)transformedValue:(id)value{
    NSInteger intVal = [value integerValue];
    
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSDictionary *theDict = [myDoc.AllDataTotalDictionaryOutlet content];
    if (theDict) {
        
        NSArray *eachArray = [theDict allValues];
        NSInteger sumTotal = [[eachArray valueForKeyPath:@"@sum.self"] integerValue];
        if (sumTotal < 1) {
            sumTotal = 1;
        }
        
        NSInteger percentI = roundf((100 * intVal) / sumTotal);
        
        
        NSString *percent = [NSString stringWithFormat:@"%li%%",percentI];
    
        return percent;
    }
    else{
        return nil;
    }
}
@end
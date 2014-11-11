//
//  Document.h
//  Nep
//
//  Created by Justin Farlow on 3/11/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVKit/AVKit.h>
#import "AppDelegate.h"
#import "ImageCanvas.h"
#import "ClassSelectorView.h"
#import "MovieCanvas.h"

@interface Document : NSPersistentDocument

@property (strong) IBOutlet AppDelegate *TheAppDelegate;


@property (strong) IBOutlet NSArrayController *CategoryControllerOutlet;
@property (strong) IBOutlet NSArrayController *DatasetControllerOutlet;
@property (strong) IBOutlet NSArrayController *SliceControllerOutlet;
@property (strong) IBOutlet NSArrayController *CharacteristicControllerOutlet;
@property (strong) IBOutlet NSDictionaryController *AllDataTotalDictionaryOutlet;




@property (weak) IBOutlet ClassSelectorView *ClassificationSelectionViewerOutlet;

@property (strong) IBOutlet ClassSelectorView *ClassSelectionViewer;




- (IBAction)GetImageStack:(id)sender;
- (IBAction)GetMovie:(id)sender;
- (IBAction)ExportData:(id)sender;

@property (weak) IBOutlet NSSlider *ImageScrollerOutlet;

- (IBAction)SelectColorsToShow:(id)sender;
@property (weak) IBOutlet NSSegmentedControl *ColorSelectorOutlet;

@property (weak) IBOutlet ImageCanvas *ImageCanvasOutlet;
@property (weak) IBOutlet MovieCanvas *MovieCanvasOutlet;

- (IBAction)CategoryForPointSelected:(id)sender;




- (IBAction)PlayTimer:(id)sender;
- (void)OnPlay;
@property (nonatomic) BOOL isPlaying;
@property NSTimer *_timer;
@property (nonatomic) float timerInterval;
@property (nonatomic) NSInteger featureDiamter;

@property (weak) IBOutlet NSTableView *TotalsTableOutlet;

- (IBAction)FeatureSelectionChanged:(id)sender;
- (IBAction)DataSelectionChanged:(id)sender;


- (IBAction)PopulateCategories:(id)sender;

- (IBAction)ChangeMovieVisability:(id)sender;
- (IBAction)ChangeMovieControlls:(id)sender;
- (IBAction)PlayMovie:(id)sender;
- (IBAction)ResetMovie:(id)sender;

@property (weak) IBOutlet NSTextField *ErrorOutlet;



-(void)ExportToFile:(NSString *)data withName:(NSString *)docName;


- (IBAction)SelectPrevious:(id)sender;
- (IBAction)SelectNext:(id)sender;


@end





@interface EachFromArray : NSValueTransformer{
}
@end
@interface Decrimented : NSValueTransformer{
}
@end
@interface Incremented : NSValueTransformer{
}
@end
@interface Totaled : NSValueTransformer{
}
@end
@interface PercentTotal : NSValueTransformer{
}
@end
@interface IsNotOne: NSValueTransformer{
}
@end


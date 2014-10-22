//
//  ImageCanvas.m
//  Nep
//
//  Created by Justin Farlow on 3/11/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import "ImageCanvas.h"
#import <Quartz/Quartz.h>
#import "Document.h"
#import "Characteristic.h"
#import "Category.h"
#import "ClassSelectorView.h"
#import "Slice.h"
#import "Dataset.h"

@implementation ImageCanvas

@synthesize imageURL;

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
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSArray *docData = [myDoc.DatasetControllerOutlet selectedObjects];
    if (docData.count>0) {
        Dataset *myData = [docData objectAtIndex:0];
        
        NSArray *characteristics = [myData.characteristics allObjects];
        
        for (Characteristic *eachChar in characteristics) {
            NSColor *theColor = eachChar.category.color;
            [theColor set];
            
            NSInteger radius = myDoc.featureDiamter;
            
            NSRect rect = NSMakeRect(([eachChar.locX floatValue]) - radius ,  ([eachChar.locY floatValue]) - radius, radius * 2, radius * 2);
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
    
    
    
    
      // Drawing code here.
    
    
}
-(void)mouseDown:(NSEvent *)theEvent{
   
    
    /*NSPoint mouseRawPoint = [theEvent locationInWindow];
    NSPoint mousePoint = [self convertPoint: mouseRawPoint fromView: nil];
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];

    
    
    NSRect thisRect = NSMakeRect(mousePoint.x - 120, mousePoint.y - 100, 120, 200);
    [myDoc.SelectClassPopover showRelativeToRect:thisRect ofView:self preferredEdge:NSMaxXEdge];
    
    */
    
}


-(void)mouseUp:(NSEvent *)theEvent{

    
    NSPoint mouseRawPoint = [theEvent locationInWindow];
    NSPoint mousePoint = [self convertPoint: mouseRawPoint fromView: nil];

    
    
    
    Document *myDoc = [[NSDocumentController sharedDocumentController] currentDocument];

    NSInteger cats = [[myDoc.CategoryControllerOutlet arrangedObjects] count] + 1;
    
    if (cats==1) {
        [myDoc PopulateCategories:self];
        cats = [[myDoc.CategoryControllerOutlet arrangedObjects] count] + 1;

    }
    
    
    NSArray *characteristics = [myDoc.CharacteristicControllerOutlet arrangedObjects];
    
    NSInteger DistanceToCheck = 20;
    NSInteger GoodToGo = 0;
    for (Characteristic *eachChar in characteristics) {
        
        
        if (abs(mousePoint.x - [eachChar.locX floatValue] ) < DistanceToCheck && abs(mousePoint.y - [eachChar.locY floatValue]) < DistanceToCheck  ) {
            GoodToGo = GoodToGo + 1;
            [myDoc.CharacteristicControllerOutlet setSelectedObjects:[NSArray arrayWithObject:eachChar]];
            [self setNeedsDisplay];
        }
        
    }
    
    if (GoodToGo == 0) {
        
        NSInteger height = (16 * cats) + (cats) + 1;
        NSRect selectRect = NSMakeRect(mouseRawPoint.x + 200, mouseRawPoint.y + 200, 220, height);
       
        
        NSRect thisRect = NSMakeRect(mousePoint.x - 120, mousePoint.y - 100, 120, 200);
       
        
        AppDelegate *myDelegate = [myDoc TheAppDelegate];
        [[myDelegate SelectCharPopover] showRelativeToRect:thisRect ofView:self preferredEdge:NSMaxXEdge];
        
        NSPoint unscaledPoint = NSMakePoint(mousePoint.x , mousePoint.y );
        
        [myDoc.ClassSelectionViewer setCarriedPoint:unscaledPoint];
        


            /*
        ClassSelectorView *selectView = myDoc.ClassificationSelectionViewerOutlet;
        NSWindow *selectWindow = [selectView window];
        [selectView setCarriedPoint:mousePoint];
        [selectWindow setFrame:selectRect display:YES animate:NSWindowAnimationBehaviorAlertPanel];
        [selectWindow makeKeyAndOrderFront:self];
             */
        }
    

    
    
}




@end





@implementation ChannelFromURL
- (id)transformedValue:(id)value{
    NSImage *theImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:value]];
    
    Document *thisDoc =  [[NSDocumentController sharedDocumentController] currentDocument];
    
    BOOL isRed =[thisDoc.ColorSelectorOutlet isSelectedForSegment:0];
    BOOL isGreen =[thisDoc.ColorSelectorOutlet isSelectedForSegment:1];
    BOOL isBlue =[thisDoc.ColorSelectorOutlet isSelectedForSegment:2];
    
    
    if (isRed == NO && isGreen == NO && isBlue == NO) {
        return theImage;
    }
    NSImage *outputImage = [self setImageWithChannels:theImage red:isRed green:isGreen blue:isBlue];
    ImageCanvas *myCanvas = thisDoc.ImageCanvasOutlet;
    NSInteger myHeight = roundl((outputImage.size.height / outputImage.size.width ) * myCanvas.frame.size.width);
    
    
    
    //[myCanvas setFrameSize:NSMakeSize(myCanvas.frame.size.width, myHeight)];
    return outputImage;
}

-(NSImage *)setImageWithChannels:(NSImage *)inputImage red:(BOOL)isRed green:(BOOL)isGreen blue:(BOOL)isBlue{
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    if (isRed ) {kRed = 1;
    }else{kRed = 0;}

    if (isBlue) {kBlue = 4;
    }else{kBlue = 0;}
    
    if (isGreen) {kGreen = 2;
    }else{kGreen = 0;}
    
    
    int colors = kGreen | kBlue | kRed;
    int m_width = inputImage.size.width;
    int m_height = inputImage.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    
    NSData * imageData = [inputImage TIFFRepresentation];
    CGImageRef imageRef;
    if(!imageData) return nil;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), imageRef);
    //CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [inputImage CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    NSImage *resultNSImage = [[NSImage alloc] initWithCGImage:image size:NSZeroSize];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultNSImage;
}

@end
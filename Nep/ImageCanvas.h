//
//  ImageCanvas.h
//  Nep
//
//  Created by Justin Farlow on 3/11/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageCanvas : NSImageView

@property (nonatomic) NSURL *imageURL;

-(void)mouseUp:(NSEvent *)theEvent;
@end





@interface ChannelFromURL : NSValueTransformer{
}
-(NSImage *)setImageWithChannels:(NSImage *)inputImage red:(BOOL)isRed green:(BOOL)isGreen blue:(BOOL)isBlue;
@end

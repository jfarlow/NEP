//
//  MovieCanvas.h
//  Nep
//
//  Created by Justin Farlow on 3/28/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MovieCanvas : AVPlayerView

@property (nonatomic, retain) AVPlayer *moviePlayer;
@property (nonatomic, retain) NSURL *movieURL;
@property (nonatomic, retain) NSString *movieURLString;



-(void)initPlayerWithURL:(NSURL*)inputURL;
-(void)initPlayerWithCurrentData;
//-(void)setNeedsDisplay;

- (void)playerItemDidReachEnd:(NSNotification *)notification;
@end

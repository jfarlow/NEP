//
//  AppDelegate.h
//  nepnodoc
//
//  Created by Justin Farlow on 3/11/14.
//  Copyright (c) 2014 UCSF. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) IBOutlet NSPopover *SelectCharPopover;



- (IBAction)saveAction:(id)sender;




@end

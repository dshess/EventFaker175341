//
//  AppDelegate.h
//  EventFaker
//
//  Created by Scott Hess on 3/4/13.
//  Copyright (c) 2013 Scott Hess. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField* field;
@property (assign) BOOL posting;

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;

@end

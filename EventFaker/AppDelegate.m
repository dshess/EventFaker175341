//
//  AppDelegate.m
//  EventFaker
//
//  Created by Scott Hess on 3/4/13.
//  Copyright (c) 2013 Scott Hess. All rights reserved.
//

#import <Carbon/Carbon.h>

#import "AppDelegate.h"

static void PostKey(ProcessSerialNumber* psnp, CGKeyCode keyCode, int flags) {
  CGEventRef keyDown = CGEventCreateKeyboardEvent(NULL, keyCode, true);
  if (flags)
    CGEventSetFlags(keyDown, flags);
  CGEventPostToPSN(psnp, keyDown);
    
  CGEventRef keyUp = CGEventCreateKeyboardEvent(NULL, keyCode, false);
  if (flags)
    CGEventSetFlags(keyUp, flags);
  CGEventPostToPSN(psnp, keyUp);
}

@implementation AppDelegate

- (void)step {
    if (!_posting)
        return;
    
    static CGKeyCode codes[] = {
        (CGKeyCode)kVK_ANSI_F,
        (CGKeyCode)kVK_ANSI_A,
        (CGKeyCode)kVK_ANSI_C,
        (CGKeyCode)kVK_ANSI_E,
        (CGKeyCode)kVK_ANSI_B,
        (CGKeyCode)kVK_ANSI_O,
        (CGKeyCode)kVK_ANSI_O,
        (CGKeyCode)kVK_ANSI_K,
        (CGKeyCode)53,
        (CGKeyCode)-1
    };
    NSTimeInterval delay;
    if (codes[_index] != (CGKeyCode)-1) {
        PostKey(&psn, codes[_index++], 0);
        delay = [_fTimeField doubleValue];
    } else {
        _index = 0;
        delay = [_escTimeField doubleValue];
    }
    [self performSelector:@selector(step) withObject:nil afterDelay:delay];
}

- (IBAction)start:(id)sender {
  NSLog(@"-start:");

  NSArray* apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:[_field stringValue]];
  if (![apps count]) {
    NSLog(@"Unable to find apps for: %@", [_field stringValue]);
    return;
  }

  if ([apps count] > 1) {
    NSLog(@"Found more than one: %@", apps);
    return;
  }

  NSRunningApplication* chrome = [apps objectAtIndex:0];
    
  if (GetProcessForPID([chrome processIdentifier], &psn) != noErr) {
    NSLog(@"Unable to fetch psn for %@", chrome);
    return;
  }

  PostKey(&psn, (CGKeyCode)kVK_ANSI_L, kCGEventFlagMaskCommand);

  _posting = YES;
  _index = 0;
  [self step];
}

- (IBAction)stop:(id)sender {
  NSLog(@"-stop:");
  _posting = NO;
}

- (void)dealloc
{
  [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
}

@end

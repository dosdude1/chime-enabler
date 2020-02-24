//
//  AppDelegate.m
//  Chime Enabler
//
//  Created by Collin Mistr on 2/22/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (!mainWindow) {
        mainWindow = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
    }
    [mainWindow showWindow:self];
}
-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}
@end

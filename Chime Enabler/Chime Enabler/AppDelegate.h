//
//  AppDelegate.h
//  Chime Enabler
//
//  Created by Collin Mistr on 2/22/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    MainWindowController *mainWindow;
}

@property (assign) IBOutlet NSWindow *window;

@end

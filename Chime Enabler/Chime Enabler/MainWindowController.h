//
//  MainWindowController.h
//  Chime Enabler
//
//  Created by Collin Mistr on 2/22/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChimeManager.h"

@interface MainWindowController : NSWindowController {
    ChimeManager *man;
    ChimeManager *xpcManager;
    ChimeState currentState;
}
@property (strong) IBOutlet NSTextField *chimeStatusLabel;
@property (strong) IBOutlet NSButton *chimeToggleButton;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;
@property (strong) IBOutlet NSTextField *statusLabel;
- (IBAction)toggleChimeState:(id)sender;

@end

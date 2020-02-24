//
//  MainWindowController.m
//  Chime Enabler
//
//  Created by Collin Mistr on 2/22/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        man = [[ChimeManager alloc] init];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self updateChimeStatus];
}
-(void)updateChimeStatus {
    currentState = [man getChimeState];
    switch(currentState) {
        case ChimeStateEnabled:
            [self.chimeStatusLabel setStringValue:@"Enabled"];
            [self.chimeToggleButton setTitle:@"Disable Chime"];
            break;
        case ChimeStateDisabled:
            [self.chimeStatusLabel setStringValue:@"Disabled"];
            [self.chimeToggleButton setTitle:@"Enable Chime"];
            break;
        default:
            [self.chimeStatusLabel setStringValue:@"Disabled"];
            [self.chimeToggleButton setTitle:@"Enable Chime"];
            break;
    }
}
- (IBAction)toggleChimeState:(id)sender {
    [self performSelectorInBackground:@selector(beginSettingChimeState) withObject:nil];
}
-(void)setUI {
    [self.progressIndicator setHidden:NO];
    [self.progressIndicator startAnimation:self];
    [self.statusLabel setHidden:NO];
    [self.chimeToggleButton setEnabled:NO];
}
-(void)resetUI {
    [self.progressIndicator stopAnimation:self];
    [self.progressIndicator setHidden:YES];
    [self.statusLabel setHidden:YES];
    [self.chimeToggleButton setEnabled:YES];
}
- (void)beginSettingChimeState {
    dispatch_async (dispatch_get_main_queue(), ^{
        [self setUI];
        switch (currentState) {
            case ChimeStateEnabled:
                [self.statusLabel setStringValue:@"Disabling Boot Chime..."];
                break;
            case ChimeStateDisabled:
                [self.statusLabel setStringValue:@"Enabling Boot Chime..."];
                break;
        }
    });
    STPrivilegedTask *t = [[STPrivilegedTask alloc] initWithLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"chimehelper"]];
    OSStatus err = [t launch];
    if (err != errAuthorizationSuccess) {
        dispatch_async (dispatch_get_main_queue(), ^{
            [self resetUI];
        });
    }
    else {
        sleep(1);
        xpcManager = (ChimeManager *)[NSConnection rootProxyForConnectionWithRegisteredName:@SERVER_ID host:nil];
        ChimeStateErr err = 0;
        switch (currentState) {
            case ChimeStateEnabled:
                err = [xpcManager setChimeState:ChimeStateDisabled];
                break;
            case ChimeStateDisabled:
                err = [xpcManager setChimeState:ChimeStateEnabled];
                break;
        }
        [xpcManager terminateHelper];
        dispatch_async (dispatch_get_main_queue(), ^{
            if (err) {
                [self handleError:err];
            }
            [self resetUI];
            [self updateChimeStatus];
        });
    }
}
-(void)handleError:(ChimeStateErr)errID {
    NSString *message = @"";
    NSString *info = @"";
    switch (errID) {
        case errSettingNVRAM:
            message = @"Error Setting NVRAM";
            info = @"An error occurred while attempting to set the NVRAM variable.";
            break;
        case errReadingNVRAM:
            message = @"Error Reading NVRAM";
            info = @"An error occurred while attempting to read the necessary NVRAM variable. The chime status cannot be updated.";
            break;
        default:
            message = @"Error";
            info = [NSString stringWithFormat:@"An unknown error occurred (%d)", errID];
            break;
    }
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert setMessageText:message];
    [alert setInformativeText:info];
    [alert addButtonWithTitle:@"OK"];
    [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
}
@end

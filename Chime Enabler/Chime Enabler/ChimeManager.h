//
//  ChimeManager.h
//  Chime Enabler
//
//  Created by Collin Mistr on 2/22/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "nvram.h"
#import "STPrivilegedTask.h"

#define SERVER_ID "com.dosdude1.chimeenabler"
#define kMuteVar "StartupMute"

typedef enum {
    ChimeStateEnabled = 0,
    ChimeStateDisabled = 1
}ChimeState;

typedef enum {
    errSettingNVRAM = 1,
    errReadingNVRAM = 2
}ChimeStateErr;

@interface ChimeManager : NSObject {
    NSConnection *connection;
    BOOL shouldKeepRunning;
}

-(id)init;
-(void)startIPCService;
-(oneway void)terminateHelper;
-(ChimeState)getChimeState;
-(ChimeStateErr)setChimeState:(ChimeState)state;

@end

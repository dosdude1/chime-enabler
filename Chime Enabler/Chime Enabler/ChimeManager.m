//
//  ChimeManager.m
//  Chime Enabler
//
//  Created by Collin Mistr on 2/22/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#import "ChimeManager.h"

@implementation ChimeManager

-(id)init {
    self = [super init];
    shouldKeepRunning = YES;
    return self;
}
-(void)startIPCService {
    connection = [[NSConnection alloc] init];
    [connection setRootObject:self];
    [connection registerName:@SERVER_ID];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    while (shouldKeepRunning && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}
-(oneway void)terminateHelper {
    NSLog(@"Helper Terminating");
    shouldKeepRunning = NO;
}

-(ChimeState)getChimeState {
    char *ret;
    int status = getNVRAMValueForKey(kMuteVar, &ret);
    if (status == 0) {
        if (ret) {
            NSString *startupMuteVal = [NSString stringWithUTF8String:ret];
            if ([startupMuteVal rangeOfString:@"%00"].location != NSNotFound) {
                return ChimeStateEnabled;
            }
        }
    }
    return ChimeStateDisabled;
}
-(ChimeStateErr)setChimeState:(ChimeState)state {
    nvramErr err = 0;
    switch (state) {
        case ChimeStateEnabled:
            err = setNVRAMValueForKey(kMuteVar, "%00");
            if (err) {
                return errSettingNVRAM;
            }
            break;
        case ChimeStateDisabled:
            err = deleteNVRAMValueForKey(kMuteVar);
            if (err) {
                return errSettingNVRAM;
            }
            break;
    }
    return 0;
}

@end

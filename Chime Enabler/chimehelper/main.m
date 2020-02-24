//
//  main.m
//  chimehelper
//
//  Created by Collin Mistr on 2/23/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChimeManager.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        ChimeManager *man = [[ChimeManager alloc] init];
        [man startIPCService];
        
    }
    return 0;
}


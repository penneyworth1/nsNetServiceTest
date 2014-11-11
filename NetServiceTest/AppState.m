//
//  AppState.m
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "AppState.h"


@implementation AppState

+(id)getInstance
{
    static AppState *appState = nil;
    @synchronized(self)
    {
        if(appState == nil)
        {
            appState = [[self alloc] init];
            appState.remoteDevices = [[NSMutableArray alloc] init];
            appState.remoteDeviceListLock = [[NSObject alloc] init];
            appState.totalBytesReceivedFromAllDevices = 0;
        }
    }
    return appState;
}



@end

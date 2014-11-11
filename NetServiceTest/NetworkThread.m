//
//  NetworkThread.m
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "NetworkThread.h"

@implementation NetworkThread

- (id)init
{
    self = [super init];
    if (self)
    {
        threadRunning = false;
        foundWorkToDo = false;
    }
    return self;
}

-(void)start
{
    threadRunning = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AppState* appState = [AppState getInstance];
        while(threadRunning)
        {
            NSLog(@"network thread firing");
            
            foundWorkToDo = false;
            for(RemoteDevice* remoteDevice in appState.remoteDevices)
            {
                if([remoteDevice hasBytesToWrite])
                {
                    foundWorkToDo = true;
                    [remoteDevice sendSomeData];
                }
                if([remoteDevice receiveSomeData])
                    foundWorkToDo = true;
            }
        
            if(!foundWorkToDo)
                [NSThread sleepForTimeInterval:1.5];
        }
    });
    
}

@end

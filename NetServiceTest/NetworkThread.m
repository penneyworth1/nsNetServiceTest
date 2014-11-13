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
        sleepTimeLength = 0.0;
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
            //NSLog(@"network thread firing");
            
            foundWorkToDo = false;
            for(RemoteDevice* remoteDevice in appState.remoteDevices)
            {
                if(remoteDevice.streamsOpen)
                {
                    if([remoteDevice hasBytesToWrite])
                    {
                        foundWorkToDo = true;
                        [remoteDevice sendSomeData];
                    }
                    if([remoteDevice receiveSomeData])
                    {
                        foundWorkToDo = true;
                    }
                }
            }
        
            if(foundWorkToDo) //If there is nothing to do, slowly increase the sleep time in between polls.
            {
                sleepTimeLength = 0;
            }
            else
            {
                if(sleepTimeLength < 1)
                    sleepTimeLength += .01;
                [NSThread sleepForTimeInterval:sleepTimeLength];
                //NSLog(@"sleep time: %f", sleepTimeLength);
            }
        }
    });
    
}

@end

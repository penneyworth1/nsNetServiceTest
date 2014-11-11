//
//  NetworkThread.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppState.h"
#import "RemoteDevice.h"

@interface NetworkThread : NSObject
{
    bool threadRunning;
    bool foundWorkToDo;
    float sleepTimeLength;
}

-(void)start;

@end

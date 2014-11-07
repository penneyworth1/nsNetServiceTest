//
//  NetworkThread.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkThread : NSObject
{
    bool threadRunning;
}

-(void)performNetworkActions;

@end

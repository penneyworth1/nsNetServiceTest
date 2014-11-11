//
//  AppState.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkThread.h"

@interface AppState : NSObject

@property NSMutableArray* remoteDevices;
@property NSObject* remoteDeviceListLock;

+(id)getInstance;


@end

//
//  RemoteDevice.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AppState.h"
#import <netinet/in.h>
#include <arpa/inet.h>

@interface RemoteDevice : NSObject <NSNetServiceDelegate>
{
    NSMutableData* bytesToWrite;
    NSMutableData* bytesReceived;
    NSObject* sendLock;
}

@property bool attemptedToConnect;
@property bool streamsOpen;
@property NSNetService* service;
@property NSMutableArray* resolvedAddresses;
@property (nonatomic, strong, readwrite) NSInputStream* inputStream;
@property (nonatomic, strong, readwrite) NSOutputStream* outputStream;

-(bool)hasBytesToWrite;
-(bool)connectToService;
-(void)addDataToSend:(NSData*)data;
-(void)sendSomeData;
-(bool)receiveSomeData;
-(bool)openStreams;

@end

//
//  RemoteDevice.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <netinet/in.h>
#include <arpa/inet.h>
@class AppState;
@class DataHandler;
@class NetMessage;

@interface RemoteDevice : NSObject <NSNetServiceDelegate>
{
    NSMutableData* bytesToWrite;
    NSMutableData* bytesReceived;
    NSObject* sendLock;
    DataHandler* dataHandler;
}

@property bool attemptedToConnect;
@property bool streamsOpen;
@property NSNetService* service;
@property NSMutableArray* resolvedAddresses;
@property (nonatomic, strong, readwrite) NSInputStream* inputStream;
@property (nonatomic, strong, readwrite) NSOutputStream* outputStream;
@property NSData* lastReceivedDataChunk;

-(bool)hasBytesToWrite;
-(bool)connectToService;
-(void)addDataToSend:(NSData*)data;
-(void)sendSomeData;
-(void)sendMessage:(NetMessage*)netMessage;
-(bool)receiveSomeData;
-(bool)openStreams;

@end

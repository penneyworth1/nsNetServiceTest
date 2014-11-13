//
//  DataHandler.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/11/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ByteUtil.h"
#import "NetMessage.h"
#import "Util.h"

typedef enum {
    READING_MESSAGE_SIZE, READING_MESSAGE_TYPE, READING_PAYLOAD
}ReadMode;

@interface DataHandler : NSObject
{
    NSMutableData* messageSizeDataReceived;
    NSMutableData* messageTypeDataReceived;
    NSMutableData* messagePayloadDataReceived;
    ReadMode readMode;
    int numberOfBytesReceived;
    int numberOfPayloadSizeBytesReceived;
    int numberOfTypeBytesReceived;
    long numberOfPayloadBytesReceived;
    long currentMessagePayloadSize;
    NetMessage* currentIncomingMessage;
}

@property NSMutableArray* outboundMessageQueue;
@property double currentReceiveMessageStartTime;


-(BOOL)addNewOutboundMessageToQueue:(NetMessage*)netMessage;
-(int)getOutboundQueueSize;
-(NSMutableArray*)addDataForIncomingMessages:(NSData*)data;

-(NSData*)dequeueNextOutboundMessage;

@end
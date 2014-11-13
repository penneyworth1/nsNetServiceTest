//
//  DataHandler.m
//  NetServiceTest
//
//  Created by Steven Stewart on 11/11/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "DataHandler.h"

@implementation DataHandler

- (id)init
{
    self = [super init];
    if (self)
    {
        self.outboundMessageQueue = [[NSMutableArray alloc] init];
        messageSizeDataReceived = [[NSMutableData alloc] init];
        messageTypeDataReceived = [[NSMutableData alloc] init];
        messagePayloadDataReceived = [[NSMutableData alloc] init];
        currentIncomingMessage = [[NetMessage alloc] init];
        readMode = READING_MESSAGE_SIZE;
    }
    return self;
}

-(BOOL)addNewOutboundMessageToQueue:(NetMessage*)netMessage
{
    NSData* messageSizeData = [ByteUtil getUtf8StringBytesWithWhitespaceForLong:netMessage.payload.length :MESSAGE_PAYLOAD_SIZE_BYTE_COUNT];
    NSData* messageTypeData = [ByteUtil getUtf8StringBytesWithWhitespaceForLong:(long)netMessage.messageType :MESSAGE_TYPE_BYTE_COUNT];
    
    NSMutableData* mutableMessageWithHeader = [messageSizeData mutableCopy];
    [mutableMessageWithHeader appendData:messageTypeData];
    [mutableMessageWithHeader appendData:netMessage.payload];
    NSData* messageWithHeader = [NSData dataWithBytes:mutableMessageWithHeader.bytes length:mutableMessageWithHeader.length];
    
    [self.outboundMessageQueue addObject:messageWithHeader];
    return YES;
}
-(int)getOutboundQueueSize
{
    return (int)[self.outboundMessageQueue count];
}
-(NSMutableArray*)addDataForIncomingMessages:(NSData*)data
{
    int bytesCopiedFromCurrentChunk = 0;
    long numberOfByesToRead = 0;
    long numberOfBytesSuccessfullyCopied = 0;
    NSMutableArray* completedPayloads = [[NSMutableArray alloc] init]; //Completed message payloads to return if any get completed
    
    while(bytesCopiedFromCurrentChunk < data.length)
    {
        if(readMode == READING_MESSAGE_SIZE)
        {
            if(numberOfPayloadSizeBytesReceived < MESSAGE_PAYLOAD_SIZE_BYTE_COUNT)
            {
                //Starting a new message. Record the time the transfer began.
                self.currentReceiveMessageStartTime = CACurrentMediaTime();
                
                numberOfByesToRead = MESSAGE_PAYLOAD_SIZE_BYTE_COUNT-numberOfPayloadSizeBytesReceived;
                numberOfBytesSuccessfullyCopied = [ByteUtil copyBytesFromDataToData:data :messageSizeDataReceived :bytesCopiedFromCurrentChunk :numberOfByesToRead];
                numberOfPayloadSizeBytesReceived += numberOfBytesSuccessfullyCopied;
                bytesCopiedFromCurrentChunk += numberOfBytesSuccessfullyCopied;
            }
            if(numberOfPayloadSizeBytesReceived == MESSAGE_PAYLOAD_SIZE_BYTE_COUNT) //We have all the bytes for the payload size. Now we must parse it as a long, and put the value into the current message instance.
            {
                currentIncomingMessage.payloadLength = [ByteUtil getLongFromUtf8Bytes:[NSData dataWithBytes:[messageSizeDataReceived bytes] length:messageSizeDataReceived.length]];
                
                currentMessagePayloadSize = currentIncomingMessage.payloadLength;
                
                //reset buffer for this message property
                [messageSizeDataReceived setLength:0];
                numberOfPayloadSizeBytesReceived = 0;
                
                //Switch to the new read type
                readMode = READING_MESSAGE_TYPE;
            }
        }
        if(readMode == READING_MESSAGE_TYPE)
        {
            if(numberOfTypeBytesReceived < MESSAGE_TYPE_BYTE_COUNT)
            {
                numberOfByesToRead = MESSAGE_TYPE_BYTE_COUNT-numberOfTypeBytesReceived;
                numberOfBytesSuccessfullyCopied = [ByteUtil copyBytesFromDataToData:data :messageTypeDataReceived :bytesCopiedFromCurrentChunk :numberOfByesToRead];
                numberOfTypeBytesReceived += numberOfBytesSuccessfullyCopied;
                bytesCopiedFromCurrentChunk += numberOfBytesSuccessfullyCopied;
            }
            if(numberOfTypeBytesReceived == MESSAGE_TYPE_BYTE_COUNT)
            {
                currentIncomingMessage.messageType = [ByteUtil getIntFromUtf8Bytes:[NSData dataWithBytes:[messageTypeDataReceived bytes] length:messageTypeDataReceived.length]];
                
                //reset buffer for this message property
                [messageTypeDataReceived setLength:0];
                numberOfTypeBytesReceived = 0;
                
                //Switch to the new read type
                readMode = READING_PAYLOAD;
            }
        }
        if(readMode == READING_PAYLOAD)
        {
            if(numberOfPayloadBytesReceived < currentMessagePayloadSize)
            {
                numberOfByesToRead = currentMessagePayloadSize-numberOfPayloadBytesReceived;
                numberOfBytesSuccessfullyCopied = [ByteUtil copyBytesFromDataToData:data :messagePayloadDataReceived :bytesCopiedFromCurrentChunk :numberOfByesToRead];
                numberOfPayloadBytesReceived += numberOfBytesSuccessfullyCopied;
                bytesCopiedFromCurrentChunk += numberOfBytesSuccessfullyCopied;
            }
            if(numberOfPayloadBytesReceived == currentMessagePayloadSize)
            {
                currentIncomingMessage.payload = [NSData dataWithBytes:[messagePayloadDataReceived bytes] length:messagePayloadDataReceived.length];
                
                //reset buffer for this message property
                [messagePayloadDataReceived setLength:0];
                numberOfPayloadBytesReceived = 0;
                
                //The current message is complete. Copy it to be sent back to the peer.
                NSData* completedPayload = [NSData dataWithBytes:currentIncomingMessage.payload.bytes length:currentMessagePayloadSize];
                [completedPayloads addObject:completedPayload];
                
                //Switch to the new read type
                readMode = READING_MESSAGE_SIZE;
                
                //Show time elapsed
                double endTime = CACurrentMediaTime();
                double seconds = endTime - self.currentReceiveMessageStartTime;
                [Util setSecondsLabel:seconds];
            }
        }
    }
    return completedPayloads;
}

-(NSData*)dequeueNextOutboundMessage
{
    if([self.outboundMessageQueue count] > 0)
    {
        NSData* data = (NSData*)[self.outboundMessageQueue objectAtIndex:0];
        [self.outboundMessageQueue removeObjectAtIndex:0];
        return data;
    }
    else
        return nil;
}

@end

//
//  NetMessage.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/12/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MESSAGE_TYPE_JSON 1
#define MESSAGE_TYPE_IPV4_ADDRESS 2
#define MESSAGE_TYPE_IPV6_ADDRESS 3

#define MESSAGE_PAYLOAD_SIZE_BYTE_COUNT 10
#define MESSAGE_TYPE_BYTE_COUNT 3

@interface NetMessage : NSObject

@property int messageType;
@property long payloadLength;
@property NSData* payload;

@end
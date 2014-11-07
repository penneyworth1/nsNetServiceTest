//
//  RemoteDevice.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#include <arpa/inet.h>

@interface RemoteDevice : NSObject <NSNetServiceDelegate>

@property NSNetService* service;
@property (nonatomic, strong, readwrite) NSInputStream* inputStream;
@property (nonatomic, strong, readwrite) NSOutputStream* outputStream;

@end

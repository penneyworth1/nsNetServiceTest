//
//  RemoteDevice.m
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "RemoteDevice.h"

@implementation RemoteDevice

- (id)init
{
    self = [super init];
    if (self)
    {
        self.attemptedToConnect = false;
        self.streamsOpen = false;
        self.resolvedAddresses = [[NSMutableArray alloc] init];
        bytesToWrite = [[NSMutableData alloc] init];
        bytesReceived = [[NSMutableData alloc] init];
        sendLock = [[NSObject alloc] init];
    }
    return self;
}

-(bool)hasBytesToWrite
{
    if([bytesToWrite length]>0)
        return true;
    else
        return false;
}

-(void)addDataToSend:(NSData*)data
{
    @synchronized(sendLock)
    {
        [bytesToWrite appendData:data];
        
        //NSLog(@"bytes to write length: %lu",(unsigned long)[bytesToWrite length]);

    }
    
    //REMOVE
    //[self sendSomeData];
}

-(void)sendSomeData
{
    @synchronized(sendLock)
    {
        NSInteger bytesWritten = [self.outputStream write:[bytesToWrite bytes] maxLength:[bytesToWrite length]];
        if(bytesWritten > 0)
        {
            //NSLog(@"%ld bytes written - %@",(long)bytesWritten,self.service.name);
            [bytesToWrite replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
        }
    }
}

-(bool)receiveSomeData
{
    if(![self.inputStream hasBytesAvailable])
    {
        //NSLog(@"No bytes available to read");
        return false;
    }
    
    int readBufferSize = 512;
    uint8_t buf[readBufferSize];
    NSInteger bytesRead = [self.inputStream read:buf maxLength:readBufferSize];
    //NSLog(@"%ld bytes read - %@",(long)bytesRead,self.service.name);
    
    if(bytesRead>0)
    {
        [Util setBytesReadLabel:bytesRead];
        return true;
    }
    else
        return false;
}

-(bool)openStreams
{
    [self.inputStream open];
    [self.outputStream open];
    
    //make sure the stream was opened
    double startTime = CACurrentMediaTime();
    
    while((CACurrentMediaTime() - startTime) < 5 && !self.streamsOpen)
    {
        //NSLog(@"elapsed time trying to open streams: %f",CACurrentMediaTime() - startTime);
        //NSLog(@"output stream status: %i",(int)[self.outputStream streamStatus]);
        //NSLog(@"input stream status: %i",(int)[self.inputStream streamStatus]);
        if([self.outputStream streamStatus] == NSStreamStatusOpen && [self.inputStream streamStatus] == NSStreamStatusOpen)
        {
            self.streamsOpen = true;
            [Util addToInfoLabel:[NSString stringWithFormat:@"tcp connection established - %@",self.service.name]];
            //NSLog(@"tcp connection established");
        }
    }
    if(self.streamsOpen)
        return true;
    else
    {
        [Util addToInfoLabel:[NSString stringWithFormat:@"Streams FAILED to open after the specified time! - %@",self.service.name]];
        //NSLog(@"Streams FAILED to open after the specified time!");
        return false;
    }
}

-(bool)connectToService
{
    bool                success;
    NSInputStream *     inStream;
    NSOutputStream *    outStream;
    success = [self.service getInputStream:&inStream outputStream:&outStream];
    if(success)
    {
        self.inputStream  = inStream;
        self.outputStream = outStream;
        
        if([self openStreams])
            return true;
        else
            return false;
    }
    else
    {
        NSLog(@"Streams FAILED to be acquired from the server! - %@", self.service.name);
        return false;
    }
}


//Net service delegate
- (void)netServiceDidPublish:(NSNetService *)service
{
    NSLog(@"%@",[NSString stringWithFormat:@"Service: %@ - %@",self.service.name,@"netServiceDidPublish"]);
}
- (void)netService:(NSNetService *)service didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"%@",[NSString stringWithFormat:@"Service: %@ - %@",self.service.name,@"didNotPublish"]);
}
- (void)netService:(NSNetService *)service didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    
}
- (void)netServiceWillResolve:(NSNetService *)service
{
    NSLog(@"%@",[NSString stringWithFormat:@"Service: %@ - %@",self.service.name,@"netServiceWillResolve"]);
    NSLog(@"%@",[NSString stringWithFormat:@"Service from parameter: %@ - %@",service.name,@"netServiceWillResolve"]);
}
- (void)netServiceDidResolveAddress:(NSNetService *)service
{
    NSLog(@"%@",[NSString stringWithFormat:@"Service: \"%@\" - %@",self.service.name,@"netServiceDidResolveAddress"]);
    NSLog(@"%@",[NSString stringWithFormat:@"Service from parameter: \"%@\" - %@",service.name,@"netServiceDidResolveAddress"]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (NSData *addressData in [service addresses])
        {
            struct sockaddr *address;
            address = (struct sockaddr*)[addressData bytes];
            switch (address->sa_family)
            {
                case AF_INET6: //IPv6
                {
                    struct sockaddr_in6 *addr6 = (struct sockaddr_in6*)address;
                    char str[INET6_ADDRSTRLEN];
                    const char *addressStr = inet_ntop(AF_INET6, &(addr6->sin6_addr), str, INET6_ADDRSTRLEN);
                    int port = ntohs(addr6->sin6_port);
                    
                    NSString *addressString = [NSString stringWithCString:addressStr encoding:NSUTF8StringEncoding];
                    
                    //Add address to list
                    [self.resolvedAddresses addObject:addressString];
                    
                    NSLog(@"Found service at (IPv6) %@:%d", addressString, port);
                    
                    break;
                }
                case AF_INET: //IPv4
                default:
                {
                    struct sockaddr_in *addr4 = (struct sockaddr_in*)address;
                    char str[INET_ADDRSTRLEN];
                    const char *addressStr = inet_ntop(AF_INET, &(addr4->sin_addr), str, INET_ADDRSTRLEN);
                    int port = ntohs(addr4->sin_port);
                    
                    NSString *addressString = [NSString stringWithCString:addressStr encoding:NSUTF8StringEncoding];
                    
                    //Add address to list
                    [self.resolvedAddresses addObject:addressString];
                    
                    NSLog(@"Found service at %@:%d", addressString, port);
                    
                    break;
                }
            }
            
            if(!self.attemptedToConnect)
            {
                self.attemptedToConnect = true;
                NSLog(@"Attempting to connect to service for remote device: %@",self.service.name);
                [self connectToService];
            }
        }
    });
    
}
- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"%@",[NSString stringWithFormat:@"Service: %@ - %@",self.service.name,@"didNotResolve"]);
}
- (void)netServiceDidStop:(NSNetService *)service
{
    NSLog(@"%@",[NSString stringWithFormat:@"Service: %@ - %@",self.service.name,@"netServiceDidStop"]);
}
- (void)netService:(NSNetService *)service didUpdateTXTRecordData:(NSData *)data
{
    NSLog(@"%@",[NSString stringWithFormat:@"Service: %@ - %@",self.service.name,@"didUpdateTXTRecordData"]);
}

@end

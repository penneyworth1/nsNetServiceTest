//
//  RemoteDevice.m
//  NetServiceTest
//
//  Created by Steven Stewart on 11/7/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "RemoteDevice.h"

@implementation RemoteDevice

- (void)connectToService
{
    BOOL                success;
    NSInputStream *     inStream;
    NSOutputStream *    outStream;
    success = [self.service getInputStream:&inStream outputStream:&outStream];
    if (!success)
    {

    }
    else
    {
        self.inputStream  = inStream;
        self.outputStream = outStream;
        [self openStreams];
    }
}
-(void)openStreams
{
    //[self.inputStream  setDelegate:self];
    //[self.inputStream  scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream  open];

    //[self.outputStream setDelegate:self];
    //[self.outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream open];
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
                NSLog(@"Found service at %@:%d", addressString, port);
                
                break;
            }
        }
    }
    
    [self connectToService];
    
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

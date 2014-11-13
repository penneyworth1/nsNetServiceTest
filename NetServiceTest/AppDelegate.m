//
//  AppDelegate.m
//  NetServiceTest
//
//  Created by Steven Stewart on 10/8/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blueColor];
    [self.window makeKeyAndVisible];
    viewController = [[ViewController alloc] init];
    viewController.delegate = self;
    [self.window setRootViewController:viewController];
    
    appState = [AppState getInstance];
    appState.viewControllerReference = viewController;
    networkThread = [[NetworkThread alloc] init];
    [networkThread start];
    
    serverRunning = NO;
    browsing = NO;
    advertising = NO;
    
    //Set up service browser
    netServiceBrowser = [[NSNetServiceBrowser alloc] init];
    netServiceBrowser.includesPeerToPeer = YES;
    [netServiceBrowser setDelegate:self];
    
    
    return YES;
}

//View controller delegate methods
- (void)viewControllerJoinPressed;
{
//    if(self.remoteService != nil)
//    {
//        [self connectToService];
//    }
}
- (void)viewControllerBrowsePressed
{
    if(!browsing)
    {
        [netServiceBrowser searchForServicesOfType:BONJOUR_TYPE inDomain:@"local"];
        [viewController showThatAppIsBrowsing:true];
        browsing = YES;
    }
    else
    {
        [netServiceBrowser stop];
        [appState.remoteDevices removeAllObjects];
        [viewController showThatAppIsBrowsing:false];
        browsing = NO;
    }
}
- (void)viewControllerAdvertisePressed
{
    //Set up the service which will be published from this phone for other devices to browse for.
    localService = [[NSNetService alloc] initWithDomain:@"local." type:BONJOUR_TYPE name:[UIDevice currentDevice].name port:0];
    localService.includesPeerToPeer = YES;
    [localService setDelegate:self];
    [localService publishWithOptions:NSNetServiceListenForConnections];
    serverRunning = YES;
    
    [viewController showThatAppIsAdvertising:true];
}
- (void)viewControllerDisconnectPressed
{
    //NSLog(@"viewControllerDisconnectPressed");
}
- (void)viewControllerSendIps
{
    @synchronized(appState.remoteDeviceListLock)
    {
        for(RemoteDevice* remoteDevice in appState.remoteDevices)
        {
            
            
            
        }
    }
}
- (void)viewControllerSend:(NSString*)message
{
    @synchronized(appState.remoteDeviceListLock)
    {
        //TESTING WITH FAKE DATA
        int sendByteArraySize = 10000000;
        void* bytes = malloc(sendByteArraySize);
        NSData* data = [NSData dataWithBytes:bytes length:sendByteArraySize];
        
        NetMessage* netMessage = [[NetMessage alloc] init];
        netMessage.messageType = MESSAGE_TYPE_JSON;
        netMessage.payload = data;
        
        for(RemoteDevice* remoteDevice in appState.remoteDevices)
        {
            //[remoteDevice addDataToSend:data];
            [remoteDevice sendMessage:netMessage];
        }
        
        //TESTING WITH FAKE DATA
        free(bytes);
    }
    
    
//    if([self.outputStream streamStatus] == NSStreamStatusOpen && [self.inputStream streamStatus] == NSStreamStatusOpen)
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            int numberOfBytesToSend = 30;
//            uint8_t output[numberOfBytesToSend];
//            int stringLenth = (int)[message length];
//            NSData * stringData = [message dataUsingEncoding:NSUTF8StringEncoding];
//            const unsigned char *stringBytes = [stringData bytes];
//            for(int i=0;i<numberOfBytesToSend;i++)
//            {
//                if(i<stringLenth)
//                    output[i] = stringBytes[i];
//                else
//                    output[i] = 0X20;
//            }
//            [self.outputStream write:output maxLength:numberOfBytesToSend];
//        });
//    }
}

//- (void)connectToService
//{
////    BOOL                success;
////    NSInputStream *     inStream;
////    NSOutputStream *    outStream;
////    
////    success = [self.remoteService getInputStream:&inStream outputStream:&outStream];
////    
////    if (!success)
////    {
////        
////    }
////    else
////    {
////        self.inputStream  = inStream;
////        self.outputStream = outStream;
////        [self openStreams];
////    }
//}

//-(void)openStreams
//{
////    [self.inputStream  setDelegate:self];
////    [self.inputStream  scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
////    [self.inputStream  open];
////    
////    [self.outputStream setDelegate:self];
////    [self.outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
////    [self.outputStream open];
//}
- (void)closeStreams
{
//    assert( (self.inputStream != nil) == (self.outputStream != nil) );      // should either have both or neither
//    if (self.inputStream != nil) {
//        [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        [self.inputStream close];
//        self.inputStream = nil;
//        
//        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        [self.outputStream close];
//        self.outputStream = nil;
//    }
}


//Net service delegate
- (void)netServiceDidPublish:(NSNetService *)service
{
    //NSLog(@"netServiceDidPublish");
}
- (void)netService:(NSNetService *)service didNotPublish:(NSDictionary *)errorDict
{
    //NSLog(@"didNotPublish");
}
- (void)netService:(NSNetService *)service didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    //NSLog(@"didAcceptConnectionWithInputStream");

    @synchronized(appState.remoteDeviceListLock)
    {
        bool remoteServiceAlreadyAdded = false;
        for(RemoteDevice* remoteDevice in appState.remoteDevices)
        {
            if([remoteDevice.service.name isEqualToString:service.name])
                remoteServiceAlreadyAdded = true;
        }
        
        if(!remoteServiceAlreadyAdded)
        {
            RemoteDevice* remoteService = [[RemoteDevice alloc] init];
            remoteService.service = service;
            remoteService.inputStream = inputStream;
            remoteService.outputStream = outputStream;
            bool streamsConnectedSuccessfully = [remoteService openStreams];
            if(streamsConnectedSuccessfully)
                [Util addToInfoLabel:[NSString stringWithFormat:@"Added remote device from the advertiser side!"]];//NSLog(@"Added remote device from the advertiser side! - %@", service.name);
            else
                [Util addToInfoLabel:[NSString stringWithFormat:@"FAILED in adding remote device from the advertiser side! streams could not open"]];//NSLog(@"FAILED in adding remote device from the advertiser side! streams could not open - %@", service.name);
            
            
            //service.delegate = self;
            
            [appState.remoteDevices addObject:remoteService];
            
            
            
            //Right now we will not resolve services from an accept on the advertiser side, but only from the browser side.
            //[service resolveWithTimeout:2.f];
        }
        
        
        //Display all discovered services on screen
        NSMutableString* foundServiceNames = [NSMutableString string];
        for(int i=0;i<[appState.remoteDevices count];i++)
        {
            RemoteDevice* remoteDevice = [appState.remoteDevices objectAtIndex:i];
            [foundServiceNames appendString:remoteDevice.service.name];
            if(i != ([appState.remoteDevices count]-1)) [foundServiceNames appendString:@","];
        }
        [viewController setDeviceInfoLabelText:foundServiceNames];
        
        //NSLog(@"didFindService other than self");
    }
}
- (void)netServiceWillResolve:(NSNetService *)service
{
    //NSLog(@"netServiceWillResolve");
}
- (void)netServiceDidResolveAddress:(NSNetService *)service
{
    //NSLog(@"netServiceDidResolveAddress");
}
- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict
{
    //NSLog(@"didNotResolve");
}
- (void)netServiceDidStop:(NSNetService *)service
{
    //NSLog(@"netServiceDidStop");
}
- (void)netService:(NSNetService *)service didUpdateTXTRecordData:(NSData *)data
{
    //NSLog(@"didUpdateTXTRecordData");
}

//Net service browser delegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    //NSLog(@"didRemoveService: %@",service.name);
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    if(![localService isEqual:service]) //ignore your own service
    {
        @synchronized(appState.remoteDeviceListLock)
        {
            RemoteDevice* remoteService = [[RemoteDevice alloc] init];
            remoteService.service = service;
            service.delegate = remoteService;
            
            [appState.remoteDevices addObject:remoteService];
            [service resolveWithTimeout:2.f];
            
            
            //Display all discovered services on screen
            NSMutableString* foundServiceNames = [NSMutableString string];
            for(int i=0;i<[appState.remoteDevices count];i++)
            {
                RemoteDevice* rd = [appState.remoteDevices objectAtIndex:i];
                [foundServiceNames appendString:rd.service.name];
                if(i != ([appState.remoteDevices count]-1)) [foundServiceNames appendString:@","];
            }
            [viewController setDeviceInfoLabelText:foundServiceNames];
            
            //NSLog(@"didFindService other than self");
        }
    }
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary *)errorDict
{
    //NSLog(@"didNotSearch");
}




//Stream delegate
//- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
//{
//    switch(eventCode)
//    {
//        case NSStreamEventOpenCompleted:
//        {
//            NSLog(@"NSStreamEventOpenCompleted");
//        } break;
//        case NSStreamEventHasSpaceAvailable:
//        {
//            NSLog(@"NSStreamEventHasSpaceAvailable");
//        } break;
//        case NSStreamEventHasBytesAvailable:
//        {
//            uint8_t buf[30];
//            NSInteger   bytesRead;
//            
//            //bytesRead = [self.inputStream read:buf maxLength:sizeof(uint8_t)];
//            NSString* receivedString = [[NSString alloc] initWithBytes:buf length:30 encoding:NSUTF8StringEncoding];
//            
//            [viewController setDeviceInfoLabelText:receivedString];
//            NSLog(@"got bytes");
//        } break;
//        case NSStreamEventErrorOccurred:
//        {
//            NSLog(@"NSStreamEventErrorOccurred");
//        } break;
//        case NSStreamEventEndEncountered:
//        {
//            NSLog(@"NSStreamEventEndEncountered");
//        } break;
//        case NSStreamEventNone:
//        {
//            NSLog(@"NSStreamEventNone");
//        } break;
//    }
//}





- (void)applicationWillResignActive:(UIApplication *)application {
    [self closeStreams];
    [localService stop];
    [netServiceBrowser stop];
    serverRunning = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

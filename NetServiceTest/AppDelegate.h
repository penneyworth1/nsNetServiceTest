//
//  AppDelegate.h
//  NetServiceTest
//
//  Created by Steven Stewart on 10/8/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "GlobalConstants.h"
#import "RemoteDevice.h"
#import <Foundation/Foundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSNetServiceDelegate,NSNetServiceBrowserDelegate,ViewControllerDelegate,NSStreamDelegate>
{
    ViewController *viewController;
    NSNetService* localService;
    NSMutableArray* remoteDevices;
    NSNetServiceBrowser* netServiceBrowser;
    BOOL serverRunning;
    BOOL browsing;
    BOOL advertising;
}

@property (strong, nonatomic) UIWindow *window;

@end


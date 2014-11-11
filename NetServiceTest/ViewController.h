//
//  ViewController.h
//  NetServiceTest
//
//  Created by Steven Stewart on 10/8/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppState.h"

@protocol ViewControllerDelegate;

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    CGRect screenRect;
    int screenWidth;
    int screenHeight;
    
    UILabel* lblFoundDevicesInfo;
    UIButton* btnJoin;
    UIButton* btnDisconnect;
    UIButton* btnBrowse;
    UIButton* btnAdvertise;
    UILabel* lblReceivedMessage;
    UITextField* tfMessageToSend;
    UIButton* btnSendMessage;
    UIButton* btnReceive;
}

@property (nonatomic, weak, readwrite) id<ViewControllerDelegate> delegate;

-(void)setDeviceInfoLabelText:(NSString*)newText;
-(void)showThatAppIsAdvertising:(bool)advertising;
-(void)showThatAppIsBrowsing:(bool)browsing;

@end

@protocol ViewControllerDelegate <NSObject>
@required
- (void)viewControllerJoinPressed;
- (void)viewControllerDisconnectPressed;
- (void)viewControllerBrowsePressed;
- (void)viewControllerAdvertisePressed;
- (void)viewControllerSend:(NSString*)message;
- (void)viewControllerReceive;
@end


//
//  ViewController.m
//  NetServiceTest
//
//  Created by Steven Stewart on 10/8/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    lblFoundDevicesInfo = [[UILabel alloc] init];
    lblFoundDevicesInfo.textColor = [UIColor whiteColor];
    lblFoundDevicesInfo.text = @"no other devices found";
    [lblFoundDevicesInfo setFont:[UIFont fontWithName:@"ArialMT" size:15]];
    [self.view addSubview:lblFoundDevicesInfo];
    lblFoundDevicesInfo.frame = CGRectMake(10, 20, 800, 30);
    
    btnJoin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btnJoin];
    [btnJoin setBackgroundColor:[UIColor blackColor]];
    [btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnJoin setTitle:@"Join" forState:UIControlStateNormal];
    [btnJoin.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    btnJoin.clipsToBounds = YES;
    btnJoin.layer.cornerRadius = 15.0f;
    [btnJoin addTarget:self action:@selector(joinButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    btnJoin.frame = CGRectMake(10, 60, 200, 30);
    
    btnDisconnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btnDisconnect];
    [btnDisconnect setBackgroundColor:[UIColor blackColor]];
    [btnDisconnect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDisconnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    [btnDisconnect.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    btnDisconnect.clipsToBounds = YES;
    btnDisconnect.layer.cornerRadius = 15.0f;
    [btnDisconnect addTarget:self action:@selector(disconnectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    btnDisconnect.frame = CGRectMake(10, 100, 200, 30);
    
    btnBrowse = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btnBrowse];
    [btnBrowse setBackgroundColor:[UIColor blackColor]];
    [btnBrowse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBrowse setTitle:@"Browse" forState:UIControlStateNormal];
    [btnBrowse.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    btnBrowse.clipsToBounds = YES;
    btnBrowse.layer.cornerRadius = 15.0f;
    [btnBrowse addTarget:self action:@selector(browseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    btnBrowse.frame = CGRectMake(10, 140, 200, 30);
    
    btnAdvertise = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btnAdvertise];
    [btnAdvertise setBackgroundColor:[UIColor blackColor]];
    [btnAdvertise setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAdvertise setTitle:@"Advertise" forState:UIControlStateNormal];
    [btnAdvertise.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    btnAdvertise.clipsToBounds = YES;
    btnAdvertise.layer.cornerRadius = 15.0f;
    [btnAdvertise addTarget:self action:@selector(advertiseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    btnAdvertise.frame = CGRectMake(10, 180, 200, 30);
    
    
    
    lblReceivedMessage = [[UILabel alloc] init];
    lblReceivedMessage.textColor = [UIColor whiteColor];
    lblReceivedMessage.text = @"waiting...";
    [lblReceivedMessage setFont:[UIFont fontWithName:@"ArialMT" size:25]];
    [self.view addSubview:lblReceivedMessage];
    lblReceivedMessage.frame = CGRectMake(10, 220, 200, 30);
    
    tfMessageToSend = [[UITextField alloc] init];
    [self.view addSubview:tfMessageToSend];
    [tfMessageToSend setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    [tfMessageToSend setBackgroundColor:[UIColor whiteColor]];
    tfMessageToSend.clipsToBounds = YES;
    tfMessageToSend.autocorrectionType = UITextAutocorrectionTypeNo;
    tfMessageToSend.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tfMessageToSend.layer.cornerRadius = 5.0f;
    tfMessageToSend.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tfMessageToSend.textAlignment = NSTextAlignmentCenter;
    tfMessageToSend.delegate = self;
    tfMessageToSend.frame = CGRectMake(10, 260, 200, 30);
    
    btnSendMessage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btnSendMessage];
    [btnSendMessage setBackgroundColor:[UIColor blackColor]];
    [btnSendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSendMessage setTitle:@"Send" forState:UIControlStateNormal];
    [btnSendMessage.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    btnSendMessage.clipsToBounds = YES;
    btnSendMessage.layer.cornerRadius = 15.0f;
    [btnSendMessage addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    btnSendMessage.frame = CGRectMake(10, 300, 200, 30);
    
    btnReceive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btnReceive];
    [btnReceive setBackgroundColor:[UIColor blackColor]];
    [btnReceive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReceive setTitle:@"Receive" forState:UIControlStateNormal];
    [btnReceive.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    btnReceive.clipsToBounds = YES;
    btnReceive.layer.cornerRadius = 15.0f;
    [btnReceive addTarget:self action:@selector(receiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    btnReceive.frame = CGRectMake(10, 340, 200, 30);
}

-(void)setDeviceInfoLabelText:(NSString*)newText
{
    lblFoundDevicesInfo.text = newText;
}
-(void)showThatAppIsAdvertising:(bool)advertising
{
    if(advertising)
    {
        [btnAdvertise setTitle:@"Advertising..." forState:UIControlStateNormal];
        [btnAdvertise setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btnAdvertise setBackgroundColor:[UIColor grayColor]];
    }
    else
    {
        [btnAdvertise setTitle:@"Advertising..." forState:UIControlStateNormal];
        [btnAdvertise setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAdvertise setBackgroundColor:[UIColor blackColor]];
    }
}
-(void)showThatAppIsBrowsing:(bool)browsing
{
    if(browsing)
    {
        [btnBrowse setTitle:@"Browsing" forState:UIControlStateNormal];
        [btnBrowse setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    else
    {
        [btnBrowse setTitle:@"Browse" forState:UIControlStateNormal];
        [btnBrowse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lblFoundDevicesInfo setText:@"-"];
    }
}

-(void)joinButtonClicked
{
    [self.delegate viewControllerJoinPressed];
}
-(void)sendButtonClicked
{
    [self.delegate viewControllerSend:tfMessageToSend.text];
}
-(void)receiveButtonClicked
{
    [self.delegate viewControllerReceive];
}
-(void)disconnectButtonClicked
{
    [self.delegate viewControllerDisconnectPressed];
}
-(void)browseButtonClicked
{
    [self.delegate viewControllerBrowsePressed];
}
-(void)advertiseButtonClicked
{
    [self.delegate viewControllerAdvertisePressed];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES]; //Dismiss keyboard
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

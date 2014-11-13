//
//  Util.m
//  NetServiceTest
//
//  Created by Steven Stewart on 11/11/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "Util.h"

@implementation Util

+(void)addToInfoLabel:(NSString*)newText
{
    AppState* appState = [AppState getInstance];
    ViewController* vc = (ViewController*)appState.viewControllerReference;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc addToInfoText:newText];
    });
}

+(void)setBytesReadLabel:(long)bytesRead
{
    AppState* appState = [AppState getInstance];
    ViewController* vc = (ViewController*)appState.viewControllerReference;
    appState.totalBytesReceivedFromAllDevices += bytesRead;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc setBytesReceivedValueText:[NSString stringWithFormat:@"%ld",appState.totalBytesReceivedFromAllDevices]];
    });
}

+(void)setSecondsLabel:(double)seconds
{
    AppState* appState = [AppState getInstance];
    ViewController* vc = (ViewController*)appState.viewControllerReference;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc setSecondsElapsedForMessageCompletion:seconds];
    });
}

@end

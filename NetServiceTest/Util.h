//
//  Util.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/11/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppState.h"
#import "ViewController.h"

@interface Util : NSObject

+(void)addToInfoLabel:(NSString*)newText;
+(void)setBytesReadLabel:(long)bytesRead;
+(void)setSecondsLabel:(double)seconds;

@end

//
//  ByteUtil.h
//  NetServiceTest
//
//  Created by Steven Stewart on 11/12/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByteUtil : NSObject

+(NSData*)getUtf8StringBytesWithWhitespaceForLong:(long)longToEncode :(int)desiredByteCount;
+(NSString*)getTrimmedUtf8StringFromData:(NSData*)data;
+(long)getLongFromUtf8Bytes:(NSData*)data;
+(int)getIntFromUtf8Bytes:(NSData*)data;
+(long)copyBytesFromDataToData:(NSData*)sourceData :(NSMutableData*)destData :(int)startReadIndex :(long)numberOfBytesToCopy;

@end

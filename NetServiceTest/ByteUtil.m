//
//  ByteUtil.m
//  NetServiceTest
//
//  Created by Steven Stewart on 11/12/14.
//  Copyright (c) 2014 Steven Stewart. All rights reserved.
//

#import "ByteUtil.h"

@implementation ByteUtil

+(NSData*)getUtf8StringBytesWithWhitespaceForLong:(long)longToEncode :(int)desiredByteCount
{
    uint8_t output[desiredByteCount];
    NSString* stringRepresentation = [NSString stringWithFormat:@"%ld",longToEncode];
    int stringLenth = (int)[stringRepresentation length];
    NSData * stringData = [stringRepresentation dataUsingEncoding:NSUTF8StringEncoding];
    const unsigned char *stringBytes = [stringData bytes];
    for(int i=0;i<desiredByteCount;i++)
    {
        if(i<stringLenth)
            output[i] = stringBytes[i];
        else
            output[i] = 0X20; //Utf8 Hex value for blank space.
    }
    NSData* data = [[NSData alloc] initWithBytes:output length:desiredByteCount];
    return data;
}

+(long)getLongFromUtf8Bytes:(NSData*)data
{
    NSString* stringFromData = [ByteUtil getTrimmedUtf8StringFromData:data];
    long longToReturn = (long)[stringFromData longLongValue];
    return longToReturn;
}

+(int)getIntFromUtf8Bytes:(NSData*)data
{
    NSString* stringFromData = [ByteUtil getTrimmedUtf8StringFromData:data];
    int intToReturn = (int)[stringFromData intValue];
    return intToReturn;
}

+(NSString*)getTrimmedUtf8StringFromData:(NSData*)data
{
    NSString * stringFromBytes = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
    NSString * trimmedStringFromBytes = [stringFromBytes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedStringFromBytes;
}

+(long)copyBytesFromDataToData:(NSData*)sourceData :(NSMutableData*)destData :(int)startReadIndex :(long)numberOfBytesToCopy
{
    if(numberOfBytesToCopy > (sourceData.length - startReadIndex))
        numberOfBytesToCopy = sourceData.length - startReadIndex;
    
    NSData* dataToCopy = [sourceData subdataWithRange:NSMakeRange(startReadIndex, numberOfBytesToCopy)];
    [destData appendBytes:[dataToCopy bytes] length:dataToCopy.length];
    
    return numberOfBytesToCopy;
}

@end

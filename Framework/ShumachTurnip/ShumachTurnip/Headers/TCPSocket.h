//
//  TCPSocket.h
//  ShumachTurnip
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>


@interface TCPSocket : NSObject
{
  CFSocketRef           _socket;
  CFReadStreamRef       _readStream;
  NSMutableData*        _readDataBuffer;
  CFWriteStreamRef      _writeStream;
  NSMutableData*        _writeDataBuffer;

  UInt16            _port;
}


@property (readwrite, nonatomic) UInt16           port;


- (id)initWithPort:(UInt16)port;
- (void)start;
- (NSData *)read;
- (unsigned int)readSize;
- (unsigned int)write:(NSData *)data;


@end

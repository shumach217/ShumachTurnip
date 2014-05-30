//
//  ShumachTurnip.h
//  ShumachTurnip
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TCPSocket;


@interface ShumachTurnip : NSObject
{
  UInt32          _port;
  TCPSocket*      _tcpSocket;
}


@property (assign, nonatomic) id              currentObject;
@property (assign, nonatomic) TCPSocket*      tcpSocket;
@property (readwrite) UInt32                  port;


- (id)initWithPort:(UInt32)port;


@end

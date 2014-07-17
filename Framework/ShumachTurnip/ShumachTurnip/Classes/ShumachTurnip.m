//
//  ShumachTurnip.m
//  ShumachTurnip
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import "ShumachTurnip.h"
#import "TCPSocket.h"
#import "TurnipCommand.h"


static NSThread*      turnipThread = nil;


@implementation ShumachTurnip


@synthesize tcpSocket = _tcpSocket;
@synthesize port = _port;


- (id)initWithPort:(UInt32)port
{
  self = [super init];

  if (self) {
    _port = port;

    dispatch_async(dispatch_get_main_queue(), ^{
      [self start];
    });
  }

  return self;
}


- (void)start
{
  _tcpSocket = [[TCPSocket alloc] initWithPort:_port];

  dispatch_async(dispatch_get_main_queue(), ^{
    [_tcpSocket start];
  });

  [self performSelector:@selector(main) onThread:[[self class] threadForRequest:self] withObject:nil waitUntilDone:NO];
}


- (void)main
{
  @try {

  } @catch (NSException *exceptino) {
 

  } @finally {

  }
}


+ (NSThread *)threadForRequest:(ShumachTurnip *)shumachTurnip
{
  if (turnipThread == nil) {
    @synchronized(self) {
      if (turnipThread == nil) {
        turnipThread = [[NSThread alloc] initWithTarget:self selector:@selector(runShumachTurnip:) object:shumachTurnip];
        [turnipThread start];
      }
    }
  }

  return turnipThread;
}


+ (void)runShumachTurnip:(ShumachTurnip *)shumachTurnip
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSLog(@"runShumachTurnip");

  while(YES) {
    [NSThread sleepForTimeInterval:0.1f];

    if ([shumachTurnip.tcpSocket readSize] != 0) {
      NSData* data = [shumachTurnip.tcpSocket read];

      NSMutableString*  request = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      //NSLog(@"%@", request);
      NSString*  response = [TurnipCommand performWithObject:request obj:(id)shumachTurnip.currentObject];

      [request release];

       NSData* writeData;

      if ([response length] == 0) {
        NSString* tmp = (NSString *)[NSMutableString stringWithString:@"invalid request\n"];
        writeData = [tmp dataUsingEncoding:NSUTF8StringEncoding];
      } else {
        writeData = [response dataUsingEncoding:NSUTF8StringEncoding];
      }

      [shumachTurnip.tcpSocket write:writeData];
    }
  }
    
  [pool release];
}


@end

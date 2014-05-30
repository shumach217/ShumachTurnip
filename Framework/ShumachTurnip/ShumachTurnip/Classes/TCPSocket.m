//
//  TCPSocket.m
//  ShumachTurnip
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import "TCPSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>


@interface TCPSocket(PrivateMethods)

static void socketAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);
static void readStreamCallBack(CFReadStreamRef stream, CFStreamEventType eventType, void *info);
static void writeStreamCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void *info);
- (void)doSocketAcceptCallBack:(CFSocketCallBackType)type socket:(CFSocketRef)sock address:(NSData *)address data:(const void *)data;
- (void)doAcceptWithNativeHandle:(CFSocketNativeHandle)newSocket;
- (BOOL)setupSocketStreamsWithNativeHandle:(CFSocketNativeHandle)nativeHandle;
- (void)doReadStreamCallBack:(CFStreamEventType)event;
- (void)doWriteStreamCallBack:(CFStreamEventType)event;
- (void)readFromStreamIntoBuffer;
- (void)writeBufferToStream:(NSData *)buffer;


@end


@implementation TCPSocket


@synthesize port = _port;


- (id)initWithPort:(UInt16)port
{
  self = [super init];

  if (self) {
    _port = port;
  }

  return self;
}


- (void)dealloc
{
  if (_readDataBuffer != nil) {
    [_readDataBuffer release];
    _readDataBuffer = nil;
  }

/*
  if (_writeDataBuffer != nil) {
    [_writeDataBuffer release];
    _writeDataBuffer = nil;
  }
  */

  [super dealloc];
}


- (void)start
{
  NSLog(@"TCPSocket start");

  CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};

  _socket = 
    CFSocketCreate(
      kCFAllocatorDefault, 
      PF_INET, 
      SOCK_STREAM, 
      IPPROTO_TCP, 
      kCFSocketAcceptCallBack, 
      (CFSocketCallBack)&socketAcceptCallBack,
      &socketCtxt 
    );
  
  if (!_socket) {
    NSLog(@"Unable to create socket.");
    return;
  }

  NSLog(@"created socket.");

  int reuse = true;
  int fileDescriptor = CFSocketGetNative(_socket);
  if (setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEADDR, (void *)&reuse, sizeof(int)) != 0) {
    NSLog(@"Unable to set socket options.");
    return;
  }

  struct sockaddr_in  address;
  memset(&address, 0, sizeof(address));
  address.sin_len = sizeof(address);
  address.sin_family = AF_INET;
  address.sin_addr.s_addr = htonl(INADDR_ANY);
  address.sin_port = htons(self.port);

  CFDataRef addressData = 
    CFDataCreate(NULL, (const UInt8 *)&address, sizeof(address));
  [(id)addressData autorelease];

  if (CFSocketSetAddress(_socket, addressData) != kCFSocketSuccess) {
    NSLog(@"Unable to bind socket to address.");
    return;
  }

  NSLog(@"binded socket to address.");
 
  CFRunLoopRef  currentRunLoop = CFRunLoopGetCurrent();
  CFRunLoopSourceRef  runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
  CFRunLoopAddSource(currentRunLoop, runLoopSource, kCFRunLoopCommonModes);
  CFRelease(runLoopSource);

}


- (NSData *)read
{
  if (_readDataBuffer == nil) {
    return nil;
  }
  
  @try {

    unsigned int  size = (unsigned int)[_readDataBuffer length];
    NSData* data = [NSData dataWithBytes:[_readDataBuffer bytes] length:size];

    NSRange rangeToDelete = {0, size};

    [_readDataBuffer replaceBytesInRange:rangeToDelete withBytes:NULL length:0];

    return data;

  } @catch (NSException *exception) {
    NSLog(@"readDataBuffer replace exception");
    @throw exception;
  } @finally {

  }

  return nil;
}


- (unsigned int)readSize
{
  if (_readDataBuffer == nil) {
    return 0;
  }

  return (unsigned int)[_readDataBuffer length];
}


- (unsigned int)write:(NSData *)data
{
  unsigned int size = (unsigned int)[data length];
  
  [self writeBufferToStream:data];

  return size;
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// PrivateMethods

static void socketAcceptCallBack(
  CFSocketRef socket, 
  CFSocketCallBackType type, 
  CFDataRef address, 
  const void *data,
  void *info
)
{
  TCPSocket*  tcpSocket = (TCPSocket *)info;

  [tcpSocket doSocketAcceptCallBack:type socket:socket address:(NSData *)address data:data];
}


static void readStreamCallBack(
  CFReadStreamRef stream, 
  CFStreamEventType eventType, 
  void *info)
{
  TCPSocket* tcpSocket = (TCPSocket*)info;
  [tcpSocket doReadStreamCallBack:eventType]; 
}


static void writeStreamCallBack(
  CFWriteStreamRef stream, 
  CFStreamEventType eventType, 
  void *info)
{
  TCPSocket* tcpSocket = (TCPSocket*)info;
  [tcpSocket doWriteStreamCallBack:eventType]; 
}


- (void)doSocketAcceptCallBack:
  (CFSocketCallBackType)type 
  socket:(CFSocketRef)sock 
  address:(NSData *)address 
  data:(const void *)data
{
  switch (type) {
  case kCFSocketConnectCallBack:
    //NSLog(@"kCFSocketConnectCallBack");
    break;

  case kCFSocketAcceptCallBack:
    //NSLog(@"kCFSocketAcceptCallBack");
    [self doAcceptWithNativeHandle:*((CFSocketNativeHandle *)data)];
    break;

  default:
    //NSLog(@"Socket %@ received unexpected CFSocketCallBackType :%lu", self, type);
    break;
  }
}


- (void)doAcceptWithNativeHandle:(CFSocketNativeHandle)nativeHandle;
{
  if (![self setupSocketStreamsWithNativeHandle:nativeHandle]) {
    return;
  }

}


- (BOOL)setupSocketStreamsWithNativeHandle:(CFSocketNativeHandle)nativeHandle
{
  CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeHandle, &_readStream, &_writeStream);

  if (_readStream == nil || _writeStream == nil) {
    //[self close];
    return NO;
  }

  _readDataBuffer = [[NSMutableData alloc] init];
  //_writeDataBuffer = [[NSMutableData alloc] init];

  // Indicate that we want socket to be closed whenever streams are closed
  CFReadStreamSetProperty(
    _readStream, 
    kCFStreamPropertyShouldCloseNativeSocket,
    kCFBooleanTrue
  );
  CFWriteStreamSetProperty(
    _writeStream, 
    kCFStreamPropertyShouldCloseNativeSocket,
    kCFBooleanTrue
  );


  // We will be handling the following stream events
  CFOptionFlags readEvents = kCFStreamEventOpenCompleted     |
                             kCFStreamEventHasBytesAvailable | 
                             kCFStreamEventEndEncountered    | 
                             kCFStreamEventErrorOccurred;

  CFOptionFlags writeEvents = kCFStreamEventOpenCompleted  |
                              kCFStreamEventCanAcceptBytes |
                              kCFStreamEventEndEncountered | 
                              kCFStreamEventErrorOccurred;

  // Setup stream context - reference to 'self' will be passed to stream event handling callbacks
  CFStreamClientContext ctx = {0, self, NULL, NULL, NULL};

  // Specify callbacks that will be handling stream events
  CFReadStreamSetClient(_readStream, readEvents, readStreamCallBack, &ctx);
  CFWriteStreamSetClient(_writeStream, writeEvents, writeStreamCallBack, &ctx);

  // Schedule streams with current run loop
  CFReadStreamScheduleWithRunLoop(
    _readStream, 
    CFRunLoopGetCurrent(),
    kCFRunLoopCommonModes
  );
  CFWriteStreamScheduleWithRunLoop(
    _writeStream, 
    CFRunLoopGetCurrent(),
    kCFRunLoopCommonModes
  );

  // Open both streams
  if ( ! CFReadStreamOpen(_readStream) || ! CFWriteStreamOpen(_writeStream)) {
    //[self close];
    return NO;
  }

  return YES;
}


// CallBacks from the read stream
- (void)doReadStreamCallBack:(CFStreamEventType)event 
{
  // Stream successfully opened
  if ( event == kCFStreamEventOpenCompleted ) {
    //NSLog(@"ReadEventOpenCompleted");
    //readStreamOpen = YES;
  } else if ( event == kCFStreamEventHasBytesAvailable ) {
    //NSLog(@"ReadEventHasBytesAvailable");
    [self readFromStreamIntoBuffer];
  } else if ( event == kCFStreamEventEndEncountered || event == kCFStreamEventErrorOccurred ) {
    // Connection has been terminated or error encountered (we treat them the same way)
    //NSLog(@"ReadEventEnd");
    // Clean everything up
    //[self close];
    // If we haven't connected yet then our connection attempt has failed
    //if ( !readStreamOpen || !writeStreamOpen ) {
      //[delegate connectionAttemptFailed:self];
    //} else {
      //[delegate connectionTerminated:self];
    //}
    //} 
  }
}


- (void)readFromStreamIntoBuffer
{
  UInt8   buf[1024];
  CFIndex len = 0;

  memset(buf, 0, sizeof(buf));

  while(CFReadStreamHasBytesAvailable(_readStream)) {
    len = CFReadStreamRead(_readStream, buf, sizeof(buf));
  }

  [_readDataBuffer appendBytes:buf length:len];
}


- (void)doWriteStreamCallBack:(CFStreamEventType)event
{
  // Stream successfully opened
  if ( event == kCFStreamEventOpenCompleted ) {
    //NSLog(@"WriteEventOpenCompleted");
    //readStreamOpen = YES;
  } else if ( event == kCFStreamEventCanAcceptBytes ) {
    //NSLog(@"WriteEvenCanAcceptBytes");
    //[self writeBufferToStream];
  } else if ( event == kCFStreamEventEndEncountered || event == kCFStreamEventErrorOccurred ) {
    //NSLog(@"WriteEvent ||");
  // Connection has been terminated or error encountered (we treat them the same way)
    // Clean everything up
    //[self close];
    // If we haven't connected yet then our connection attempt has failed
    //if ( !readStreamOpen || !writeStreamOpen ) {
      //[delegate connectionAttemptFailed:self];
    //} else {
      //[delegate connectionTerminated:self];
    //}
    //} 
  }
}


- (void)writeBufferToStream:(NSData *)buffer;
{
  BOOL  isDone = NO;

  if ([buffer length] == 0) {
    return;
  }

  if (!CFWriteStreamCanAcceptBytes(_writeStream)) {
    return;
  }

  while (!isDone) {

    CFIndex writtenBytes = CFWriteStreamWrite(_writeStream, [buffer bytes], [buffer length]);

    if (writtenBytes >= 0) {
      isDone = YES;
    
    } else {
      NSLog(@"writtenBytes < 0");
    }
  }
}


@end

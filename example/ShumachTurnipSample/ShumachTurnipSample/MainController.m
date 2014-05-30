//
//  MainController.m
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import "MainController.h"


static MainController*  mainController;


@implementation MainController


+ (id)getMainController
{
  if (mainController == nil) {
    mainController = [[MainController alloc] init];
  }

  return mainController;
}


- (id)init
{
  self = [super init];

  if (self) {

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];

    _mainIndexViewController = [[MainIndexViewController alloc] initWithNibName:nil bundle:nil];
    [_window addSubview:_mainIndexViewController.view];

    _shumachTurnip = [[ShumachTurnip alloc] initWithPort:8000];
    _shumachTurnip.currentObject = self;
  }

  return self;
}


- (void)dealoc
{
  if (_mainIndexViewController != nil) {
    [_mainIndexViewController release];
    _mainIndexViewController = nil;
  }

  if (_shumachTurnip != nil) {
    [_shumachTurnip release];
    _shumachTurnip = nil;
  }

  [super dealloc];
}


- (void)reset
{
  NSLog(@"reset @MainControlelr");
  if (_mainIndexViewController != nil) {
    _mainIndexViewController.view.hidden = YES;
    [_mainIndexViewController release];
    _mainIndexViewController = nil;
  }

  _mainIndexViewController = [[MainIndexViewController alloc] initWithNibName:nil bundle:nil];
  [_window addSubview:_mainIndexViewController.view];

}


- (BOOL)testBOOL:(BOOL)value
{
  return value;
}


- (char)testChar:(char)value
{
  return value;
}


- (double)testDouble:(double)value
{
  return value;
}


- (float)testFloat:(float)value
{
  return value;
}


- (int)testInt:(int)value
{
  return value;
}


- (NSInteger)testNSInteger:(NSInteger)value
{
  return value;
}


- (long)testLong:(long)value
{
  return value;
}


- (long long)testLongLong:(long long)value
{
  return value;
}


- (short)testShort:(short)value
{
  return value;
}


- (unsigned char)testUnsignedChar:(unsigned char)value
{
  return value;
}


- (unsigned int)testUnsignedInt:(unsigned int)value
{
  return value;
}


- (NSUInteger)testNSUInteger:(NSUInteger)value
{
  return value;
}


- (unsigned long)testUnsignedLong:(unsigned long)value
{
  return value;
}


- (unsigned long long)testUnsignedLongLong:(unsigned long long)value
{
  return value;
}


- (unsigned short)testUnsignedShort:(unsigned short)value
{
  return value;
}


@end

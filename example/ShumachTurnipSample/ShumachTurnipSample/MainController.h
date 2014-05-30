//
//  MainController.h
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <ShumachTurnip/ShumachTurnip.h>
#import "MainIndexViewController.h"


@interface MainController : NSObject
{
  UIWindow*                   _window;
  MainIndexViewController*    _mainIndexViewController;

  ShumachTurnip*              _shumachTurnip;
}


+ (id)getMainController;
- (void)reset;


@end

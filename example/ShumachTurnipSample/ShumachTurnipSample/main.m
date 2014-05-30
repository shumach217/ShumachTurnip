//
//  main.m
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
  @try {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
  } @catch (NSException *exception) {
    NSLog(@"%@", [exception callStackSymbols]);
    @throw exception;
  } @finally {

  }
}

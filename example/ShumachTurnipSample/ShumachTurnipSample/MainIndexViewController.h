//
//  MainIndexViewController.h
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternA_1ViewController.h"
#import "PatternB_1ViewController.h"


@interface MainIndexViewController : UITabBarController
{
  PatternA_1ViewController*     _patternA_1ViewController;
  UINavigationController*       _patternBNavigationController;
  PatternB_1ViewController*     _patternB_1ViewController;
}


@end

//
//  PatternB_1ViewController.h
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternB_2ViewController.h"


@interface PatternB_1ViewController : UIViewController
<
PatternB_2ViewControllerDelegate
>
{
  PatternB_2ViewController*     _patternB_2ViewController;
  UIBarButtonItem*              _nextButton;
}


@end

//
//  PatternB_2ViewController.h
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PatternB_2ViewControllerDelegate
- (void)patternB_2ViewControllerDidFinish;
@end


@interface PatternB_2ViewController : UIViewController
{
  UIBarButtonItem*              _closeButton;
  UILabel*                      _label;
}


@property (assign, nonatomic) id <PatternB_2ViewControllerDelegate> delegate;


- (void)setUILabel:(NSString *)string;
- (void)setUILabel:(NSString *)string frame:(CGRect)frame;
- (void)setUILabel:(NSString *)string x:(float)x y:(float)y width:(float)width height:(float)height;


@end

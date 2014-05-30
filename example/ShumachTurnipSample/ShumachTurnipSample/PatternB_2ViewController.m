//
//  PatternB_2ViewController.m
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//


#import "PatternB_2ViewController.h"


@interface PatternB_2ViewController (PrivateMethods)
- (void)pushedCloseButton:(id)sender;
- (BOOL)test;
@end


@implementation PatternB_2ViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }

  return self;
}


- (void)dealloc
{
  if (_closeButton != nil) {
    [_closeButton release];
    _closeButton = nil;
  }
  
  [super dealloc];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  _closeButton = [[UIBarButtonItem alloc]
    initWithTitle:@"Close"
    style:UIBarButtonItemStyleBordered
    target:self
    action:@selector(pushedCloseButton:)];

  self.navigationItem.leftBarButtonItem = _closeButton;

  [self setUILabel:@"patternB_2"];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)setUILabel:(NSString *)string
{
  CGRect  frame = CGRectMake(80.0f, 50.0f, 100.0f, 100.0f);

  [self setUILabel:string frame:frame];
}


- (void)setUILabel:(NSString *)string frame:(CGRect)frame;
{
  if (_label != nil) {
    _label.hidden = YES;
    [_label release];
  }

  _label = [[UILabel alloc] initWithFrame:frame];

  _label.text = string;
  _label.textColor = [UIColor blueColor];
  [self.view addSubview:_label];
}


- (void)setUILabel:(NSString *)string x:(float)x y:(float)y width:(float)width height:(float)height
{
  CGRect  frame = CGRectMake(x, y, width, height);

  NSLog(@"setUILabel 4");
  [self setUILabel:string frame:frame];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// PrivateMethods

- (void)pushedCloseButton:(id)sender
{
  [self.delegate patternB_2ViewControllerDidFinish];
}


@end

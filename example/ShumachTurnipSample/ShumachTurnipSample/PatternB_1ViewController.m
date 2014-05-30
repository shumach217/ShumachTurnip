//
//  PatternB_1ViewController.m
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import "PatternB_1ViewController.h"


@interface PatternB_1ViewController (PrivateMethods)
- (void)pushedNextButton:(id)sender;
- (void)patternB_2ViewControllerDidFinish;
@end


@implementation PatternB_1ViewController


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
  if (_patternB_2ViewController != nil) {
    [self.navigationController popViewControllerAnimated:NO];
    [_patternB_2ViewController release];
    _patternB_2ViewController = nil;
  }

  [super dealloc];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  _nextButton = [[UIBarButtonItem alloc]
    initWithTitle:@"Next"
    style:UIBarButtonItemStyleBordered
    target:self
    action:@selector(pushedNextButton:)];

  self.navigationItem.rightBarButtonItem = _nextButton;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// PrivateMethods

- (void)pushedNextButton:(id)sender
{
  if (_patternB_2ViewController != nil) {
    [_patternB_2ViewController release];
    _patternB_2ViewController = nil;
  }

  _patternB_2ViewController = [[PatternB_2ViewController alloc] initWithNibName:nil bundle:nil];
  _patternB_2ViewController.delegate = (id<PatternB_2ViewControllerDelegate>)self;
  [self.navigationController pushViewController:_patternB_2ViewController animated:NO];
}


- (void)patternB_2ViewControllerDidFinish
{
  [self.navigationController popViewControllerAnimated:NO];

  [_patternB_2ViewController release];
  _patternB_2ViewController = nil;
}


@end

//
//  MainIndexViewController.m
//  ShumachTurnipSample
//
//  Created by shusaku FUKUMINE on 2014/03/07.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import "MainIndexViewController.h"

@interface MainIndexViewController ()

@end


@implementation MainIndexViewController


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
  if (_patternA_1ViewController != nil) {
    [_patternA_1ViewController.tabBarItem release];
    _patternA_1ViewController.tabBarItem = nil;
    [_patternA_1ViewController release];
    _patternA_1ViewController = nil;
  }

  if (_patternB_1ViewController != nil) {
    [_patternB_1ViewController release];
    _patternB_1ViewController = nil;
  }

  if (_patternBNavigationController != nil) {
    [_patternBNavigationController.tabBarItem release];
    _patternBNavigationController.tabBarItem = nil;
    [_patternBNavigationController release];
    _patternBNavigationController = nil;
  }

  [super dealloc];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  _patternA_1ViewController = [[PatternA_1ViewController alloc] initWithNibName:nil bundle:nil];
  _patternA_1ViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"PatternA" image:nil tag:0];

  _patternBNavigationController = [[UINavigationController alloc] initWithNibName:nil bundle:nil];
  _patternB_1ViewController = [[PatternB_1ViewController alloc] initWithNibName:nil bundle:nil];
  [_patternBNavigationController pushViewController:_patternB_1ViewController animated:NO];
  _patternBNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"PatternB" image:nil tag:1];
  _patternBNavigationController.navigationBar.tintColor = [UIColor whiteColor];
  _patternBNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
 

  self.viewControllers = [NSArray arrayWithObjects:
    _patternA_1ViewController,
    _patternBNavigationController,
    nil
  ];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

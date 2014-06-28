//
//  MainIndexViewController.swift
//  ShumachTurnipSampleSwift
//
//  Created by shusaku FUKUMINE on 2014/06/12.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//


import UIKit


class MainIndexViewController: UITabBarController {


  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    // Custom initialization
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    var patternA_1ViewController = PatternA_1ViewController(nibName: nil, bundle: nil);
    patternA_1ViewController.tabBarItem.title = "PatternA"

    var patternBNavigationController = UINavigationController(nibName: nil, bundle: nil);
    patternBNavigationController.navigationBar.tintColor = UIColor.whiteColor()
    patternBNavigationController.navigationBar.barTintColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
    var patternB_1ViewController = PatternB_1ViewController(nibName: nil, bundle: nil);
    patternBNavigationController.tabBarItem.title = "PatternB"
    patternBNavigationController.pushViewController(patternB_1ViewController, animated: false)

    var controllerList:Array = [
      patternA_1ViewController,
      patternBNavigationController
    ]

    self.setViewControllers(controllerList, animated: true)

  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    

  func reset() {
    var patternA_1ViewController = self.viewControllers[0] as PatternA_1ViewController
    patternA_1ViewController.reset()

    var patternBNavigationController = self.viewControllers[1] as UINavigationController
    patternBNavigationController.viewControllers[0].reset()
    self.selectedIndex = 0 
  }

}

//
//  PatternB_1ViewController.swift
//  ShumachTurnipSampleSwift
//
//  Created by shusaku FUKUMINE on 2014/06/12.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

import UIKit


class PatternB_1ViewController: UIViewController, PatternB_2ViewControllerDelegate {


  var patternB_2ViewController: PatternB_2ViewController?


  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    // Custom initialization

    self.view.backgroundColor = UIColor.whiteColor()
  }


  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    var nextButton = UIBarButtonItem(title: "Next", style: .Bordered, target: self, action: "pushedNextButton:")

    self.navigationItem.rightBarButtonItem = nextButton;
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    

  func reset() {

    self.navigationController.popViewControllerAnimated(false)
    self.patternB_2ViewController = nil
  }


  func pushedNextButton(barButtonItem: UIBarButtonItem) {

    self.patternB_2ViewController = PatternB_2ViewController(nibName: nil, bundle: nil)
    self.patternB_2ViewController!.delegate = self
    self.navigationController.pushViewController(patternB_2ViewController, animated: false)

  }


  func patternB_2ViewControllerDidFinish() {
    
    self.navigationController.popViewControllerAnimated(false)
    self.patternB_2ViewController = nil

  }

}

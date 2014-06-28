//
//  PatternB_2ViewController.swift
//  ShumachTurnipSampleSwift
//
//  Created by shusaku FUKUMINE on 2014/06/12.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

import UIKit


@objc protocol PatternB_2ViewControllerDelegate {
  func patternB_2ViewControllerDidFinish()
}


class PatternB_2ViewController: UIViewController {


  var   label: UILabel?
  weak  var delegate: PatternB_2ViewControllerDelegate?


  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    // Custom initialization
  }


  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    var closeButton = UIBarButtonItem(title: "Close", style: .Bordered, target: self, action: "pushedCloseButton:")
    self.navigationItem.rightBarButtonItem = closeButton;
    self.label = UILabel(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
    self.label!.text = "PatternB_2"
    self.view!.addSubview(self.label)
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func pushedCloseButton(barButtonItem: UIBarButtonItem) {

    self.delegate?.patternB_2ViewControllerDidFinish()

  }
    
  func changeLabelText(text: String) {
    self.label!.text = text
  }

}

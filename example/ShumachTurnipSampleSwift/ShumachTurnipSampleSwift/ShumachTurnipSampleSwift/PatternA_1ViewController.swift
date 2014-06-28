//
//  PatternA_1ViewController.swift
//  ShumachTurnipSampleSwift
//
//  Created by shusaku FUKUMINE on 2014/06/12.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

import UIKit


class PatternA_1ViewController: UIViewController {


  var boolValue: Bool = false
  var doubleValue: Double = 1.23456789012
  var floatValue: Float = 1.2345
  var intValue: Int = 1234567890
  var uintValue: UInt = 2240


  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    // Custom initialization
    self.view.backgroundColor = UIColor.blueColor()
  }


  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    

  func reset() {

    self.boolValue = false
    self.doubleValue = 1.23456789012
    self.floatValue = 1.2345
    self.intValue = 1234567890
    self.uintValue = 2240

    self.view.backgroundColor = UIColor.blueColor()
  }


  func testBOOL(val: Bool) -> Bool {
    return val
  }


  func testDouble(val: Double) -> Double {
    return val
  }


  func testFloat(val: Float) -> Float {
    return val
  }


  func testInt(val: Int) -> Int {
    return val
  }


  func testNSInteger(val: NSInteger) -> NSInteger {
    return val
  }


  func testUInt(val: UInt) -> UInt {
    return val
  }


  func testString(val: String) -> String {
    return val
  }


  func testMultiArg(val1: Int, val2: Int) -> Int {
    var val = val1 + val2;

    return val;
  }


  func changeBackgroundColor(text: String) {
    if (text == "red") {
      self.view.backgroundColor = UIColor.redColor()
    } else if (text == "blue") {
      self.view.backgroundColor = UIColor.blueColor()
    }
  }

}

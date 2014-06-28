//
//  MainController.swift
//  ShumachTurnipSampleSwift
//
//  Created by shusaku FUKUMINE on 2014/06/12.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//


import UIKit
import ShumachTurnip


var mainController: MainController?


class MainController: NSObject {
   

  var window: UIWindow?
  var mainIndexViewController: MainIndexViewController?
  var turnip: ShumachTurnip?
  var boolValue: Bool = false
  var doubleValue: Double = 1.23456789012
  var floatValue: Float = 1.2345
  var intValue: Int = 1234567890
  var uintValue: UInt = 2240
  var stringValue: String?


  class func getMainController() -> MainController {
    if mainController != nil {
      return mainController!;
    } else {
      mainController = MainController()
      return mainController!;
    }
  }


  init() {
    super.init()
    self.doubleValue = 1.23456789012
    self.floatValue = 1.2345
    self.boolValue = false
    self.intValue = 1234567890

    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()

    self.mainIndexViewController = MainIndexViewController(nibName:nil, bundle:nil);
    self.window!.addSubview(self.mainIndexViewController!.view)

    self.turnip = ShumachTurnip(port: 8000)
    self.turnip!.currentObject = self;

    self.stringValue = "Hoge"
  }


  func reset() {
    self.boolValue = false
    self.doubleValue = 1.23456789012
    self.floatValue = 1.2345
    self.intValue = 1234567890
    self.uintValue = 2240
    self.stringValue = "Hoge"

    self.mainIndexViewController!.reset()
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

}

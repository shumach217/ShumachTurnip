# coding: utf-8
require './lib/tcp_adapter.rb'
require 'json'


PATHS = [
  ['CurrentObject', ""],
  ['MainIndexViewController', "_mainIndexViewController"],
  ['MainIndexViewControllerSelectedIndex', "selectedIndex"],
  ['MainIndexViewControllerSelectedViewController', "selectedViewController"],
  ['PatternA_1ViewController', "viewControllers.0"],
  ['PatternB_1ViewController', "_mainIndexViewController.selectedViewController.topViewController"],
  ['PatternB_2ViewController', "_mainIndexViewController.selectedViewController.topViewController"]
]


step "コネクション確立" do

  @adapter = ShumachTurnip::ConnectionAdapters::TCPAdapter.new '172.20.10.1', 8000

end


step "コネクション破棄" do
  @adapter.close
end


step "アプリリセット" do
  action = { 
    "type" => "method", 
    "methodName" => "reset", 
    "args" => []
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
end


step "MainController確認" do

  @path = PATHS.assoc("CurrentObject").last
  action = { "type" => "getObject", "args" => [] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"getObject\",\"success\":\"true\",\"return\":\"MainController\"}'
end

 
step "BOOLテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testBOOL:", 
    "args" => ["YES"]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testBOOL:","return":true}'
end


step "Charテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testChar:", 
    "args" => ['A']
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
end


step "Doubleテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testDouble:", 
    "args" => [1.23456789012]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testDouble:","return":1.23456789012}'
end


step "Floatテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testFloat:", 
    "args" => [1.2345]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testFloat:","return":1.2345}'
end


step "Intテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testInt:", 
    "args" => [1234567890]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testInt:","return":1234567890}'
end


step "NSIntegerテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testNSInteger:", 
    "args" => [100]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  p response
end


step "Longテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testLong:", 
    "args" => [-1234567890]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testLong:","return":-1234567890}'
end


step "LongLongテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testLongLong:", 
    "args" => [-123456789012345]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testLongLong:","return":-123456789012345}'
end


step "Shortテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testShort:", 
    "args" => [-2000]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testShort:","return":-2000}'
end


step "UnsignedCharテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testUnsignedChar:", 
    "args" => [244]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testUnsignedChar:","return":244}'
end


step "UnsignedIntテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testUnsignedInt:", 
    "args" => [2440]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testUnsignedInt:","return":2440}'
end


step "NSUIntegerテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testNSUInteger:", 
    "args" => [2440]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testNSUInteger:","return":2440}'
end


step "UnsignedLongテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testUnsignedLong:", 
    "args" => [1234567890]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testUnsignedLong:","return":1234567890}'
end


step "UnsignedLongLongテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testUnsignedLongLong:", 
    "args" => [123456789012345]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testUnsignedLongLong:","return":123456789012345}'
end


step "UnsignedShortテスト" do
  action = { 
    "type" => "method", 
    "methodName" => "testUnsignedShort:", 
    "args" => [2000]
  }

  hash = { "target" => "", "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testUnsignedShort:","return":2000}'
end


step ":num MainIndexTabタブ切替" do |num|
  @path = PATHS.assoc("MainIndexViewController").last
  arg = { "key" => "selectedIndex", "valueType" => "int", "value" => num.to_i }
  action = { "type" => "setValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
end


step ":num MainIndexTabタブ確認" do |num|

  @path = PATHS.assoc("MainIndexViewController").last
  arg = { "key" => "selectedIndex" }
  action = { "type" => "valueForKey", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"valueForKey\",\"success\":\"true\",\"return\":' + num + '}'
end


step "PatternB_2へ進む" do 
  @path = PATHS.assoc("PatternB_1ViewController").last
  arg = { "dataType" => "id", "data" => "nil" }
  action = { 
    "type" => "method", 
    "methodName" => "pushedNextButton:", 
    "args" => arg
  }


  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

end


step ":str Labelセット" do |str|
  @path = PATHS.assoc("PatternB_2ViewController").last
  arg = { "valueType" => "NSString", "value" => str }
  action = { 
    "type" => "method", 
    "methodName" => "setUILabel:", 
    "args" => [arg]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  expect(response).to match '{\"type\":\"method\",\"methodName\":\"setUILabel:\",\"return\":\"nil\"}'
end


step ":str Label2セット" do |str|
  @path = PATHS.assoc("PatternB_2ViewController").last
  arg = { "valueType" => "NSString", "value" => str}
  action = { 
    "type" => "method", 
    "methodName" => "setUILabel:x:y:width:height:", 

    "args" => [arg, 80.0, 50.0, 200.0, 100.0]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  expect(response).to match '{\"type\":\"method\",\"methodName\":\"setUILabel:x:y:width:height:\",\"return\":\"nil\"}'
end


step "testを実行" do 
  @path = PATHS.assoc("PatternB_2ViewController").last
  action = { 
    "type" => "method", 
    "methodName" => "test", 
    "args" => [], 
    "isReturnValue" => "true", 
    "returnValueType" => "BOOL"
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  expect(response).to match '{\"type\":\"method\",\"success\":\"true\",\"return\":\"YES\"}'
end

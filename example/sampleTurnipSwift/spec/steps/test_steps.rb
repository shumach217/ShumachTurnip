# coding: utf-8
require './lib/tcp_adapter.rb'
require 'json'


PATHS = [
  ['CurrentObject', ""],
  ['MainController', ""],
  ['MainIndexViewController', "mainIndexViewController"],
  ['PatternA_1ViewController', "mainIndexViewController.viewControllers.0"],
  ['PatternB_1ViewController', "mainIndexViewController.viewControllers.1"],
  ['SelectedPatternB_1ViewController', "mainIndexViewController.selectedViewController.topViewController"],
  ['SelectedPatternB_2ViewController', "mainIndexViewController.selectedViewController.topViewController"]
]


step "Connection Establishment" do

  # @adapter = ShumachTurnip::ConnectionAdapters::TCPAdapter.new '172.20.10.1', 8000
  @adapter = ShumachTurnip::ConnectionAdapters::TCPAdapter.new '192.168.24.55', 8000

end


step "Connection Release" do
  @adapter.close
end


step "Application Reset" do
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


step "Confirm MainController" do

  @path = PATHS.assoc("CurrentObject").last
  action = { "type" => "getObject", "args" => [] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)

  expect(response).to include("MainController")
end

 
step "Method BOOL Test" do
  @path = PATHS.assoc("PatternA_1ViewController").last

  action = { 
    "type" => "method", 
    "methodName" => "testBOOL:", 
    "args" => ["YES"]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testBOOL:","return":true}'
end


step "Method Double Test" do
  @path = PATHS.assoc("PatternA_1ViewController").last
  action = { 
    "type" => "method", 
    "methodName" => "testDouble:", 
    "args" => [1.23456789012]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testDouble:","return":1.23456789012}'
end


step "Method Float Test" do
  @path = PATHS.assoc("PatternA_1ViewController").last
  action = { 
    "type" => "method", 
    "methodName" => "testFloat:", 
    "args" => [1.2345]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testFloat:","return":1.2345}'
end


step "Method Int Test" do
  @path = PATHS.assoc("PatternA_1ViewController").last
  action = { 
    "type" => "method", 
    "methodName" => "testInt:", 
    "args" => [1234567890]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testInt:","return":1234567890}'
end


step "Method UInt Test" do
  @path = PATHS.assoc("PatternA_1ViewController").last
  action = { 
    "type" => "method", 
    "methodName" => "testUInt:", 
    "args" => [2440]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testUInt:","return":2440}'
end


step "Method String Test" do
  @path = PATHS.assoc("PatternA_1ViewController").last
  arg = { "valueType" => "NSString", "value" => "hoge" }
  action = { 
    "type" => "method", 
    "methodName" => "testString:", 
    "args" => [arg]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testString:","return":"hoge"}'
end


step "Method 2 Arguments Test :val1 :val2" do |val1, val2|
  @path = PATHS.assoc("PatternA_1ViewController").last
  action = { 
    "type" => "method", 
    # "methodName" => "testMultiArg:val2", 
    "methodName" => "testMultiArg:val2:", 
    "args" => [val1.to_i, val2.to_i]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  val = val1.to_i + val2.to_i

  response = @adapter.gets
  expect(response).to match '{"type":"method","methodName":"testMultiArg:val2:","return":' + val.to_s + '}'
end


step "Change BackgroundColor :color" do |color| 
  @path = PATHS.assoc("PatternA_1ViewController").last
  arg = { "valueType" => "NSString", "value" => color }
  action = { 
    "type" => "method", 
    "methodName" => "changeBackgroundColor:", 
    "args" => [arg]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets
end


step "Get Instance BOOL Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "boolValue", "type" => "B" }
  action = { "type" => "getInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"getInstanceValue\",\"success\":\"true\",\"return\":' + val + '}'

end


step "Set Instance BOOL Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "boolValue", "value" => val, "type" => "B" }
  action = { "type" => "setInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"setInstanceValue\",\"success\":\"true\",\"return\":\"nil\"}'

end


step "Get Instance Double Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "doubleValue", "type" => "d" }
  action = { "type" => "getInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"getInstanceValue\",\"success\":\"true\",\"return\":' + val + '}'

end


step "Set Instance Double Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "doubleValue", "value" => val, "type" => "d" }
  action = { "type" => "setInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"setInstanceValue\",\"success\":\"true\",\"return\":\"nil\"}'

end


step "Get Instance Float Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "floatValue", "type" => "f" }
  action = { "type" => "getInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"getInstanceValue\",\"success\":\"true\",\"return\":' + val + '}'

end


step "Set Instance Float Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "floatValue", "value" => val, "type" => "f" }
  action = { "type" => "setInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"setInstanceValue\",\"success\":\"true\",\"return\":\"nil\"}'

end


step "Get Instance Int Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "intValue", "type" => "i" }
  action = { "type" => "getInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"getInstanceValue\",\"success\":\"true\",\"return\":' + val + '}'
end


step "Set Instance Int Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "intValue", "value" => val.to_i, "type" => "i" }
  action = { "type" => "setInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"setInstanceValue\",\"success\":\"true\",\"return\":\"nil\"}'

end


step "Get Instance UInt Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "uintValue", "type" => "I" }
  action = { "type" => "getInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"getInstanceValue\",\"success\":\"true\",\"return\":' + val + '}'
end

 
step "Set Instance UInt Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "uintValue", "value" => val.to_i, "type" => "I" }
  action = { "type" => "setInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"setInstanceValue\",\"success\":\"true\",\"return\":\"nil\"}'

end


step "Get Instance String Test :value" do |val|

  @path = PATHS.assoc("MainController").last
  arg = { "name" => "stringValue", "type" => "@" }
  action = { "type" => "getInstanceValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"type\":\"getInstanceValue\",\"success\":\"true\",\"return\":' + val + '}'
end


step "MainIndexTab Switch To :num" do |num|
  @path = PATHS.assoc("MainIndexViewController").last
  arg = { "key" => "selectedIndex", "valueType" => "int", "value" => num.to_i }
  action = { "type" => "setValue", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 

  @adapter.write msg

  response = @adapter.gets
end


step "Confirm MainIndexTab :num" do |num|

  @path = PATHS.assoc("MainIndexViewController").last
  arg = { "key" => "selectedIndex" }
  action = { "type" => "valueForKey", "args" => [arg] }
  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  idx = response.length
  response.slice!(idx, 1)
  expect(response).to match '{\"status\":\"success\",\"type\":\"valueForKey\",\"return\":' + num + '}'

end


step "Go to PatternB_2" do
  @path = PATHS.assoc("SelectedPatternB_1ViewController").last
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


step "Change Label text :str" do |str|
  @path = PATHS.assoc("SelectedPatternB_2ViewController").last
  arg = { "valueType" => "NSString", "value" => str }
  action = { 
    "type" => "method", 
    "methodName" => "changeLabelText:", 
    "args" => [arg]
  }

  hash = { "target" => @path, "action" => action }
  msg = hash.to_json 
  @adapter.write msg

  response = @adapter.gets

  expect(response).to match '{\"type\":\"method\",\"methodName\":\"changeLabelText:\",\"return\":\"nil\"}'
end

//
//  JsonUtils.m
//  ShumachTurnip
//
//  Created by shusaku FUKUMINE on 2014/03/08.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import "JsonUtils.h"
#import "JSON.h"


@implementation JsonUtils


+ (id)parseJson:(NSString *)jsonStr
{
  SBJSON  *jsonParser = [SBJSON new];

  id result = [jsonParser objectWithString:jsonStr];

  if (![result isKindOfClass:[NSArray class]]) {
    if ([result objectForKey:@"error"] != nil) {
      NSLog(@"error");
      return nil;
    }
  }
  [jsonParser release];

  return result;
}


+ (NSString *)generateJson:(id)obj
{
  SBJsonWriter*  writer = [[SBJsonWriter alloc] init];
  NSString* str = [writer stringWithObject:obj];

  [writer release];

  return str;
}


@end

//
//  TurnipCommand.m
//  ShumachTurnip
//
//  Created by shusaku FUKUMINE on 2014/03/08.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import <objc/runtime.h>
#import "TurnipCommand.h"
#import "JsonUtils.h"


@interface TurnipCommand(PrivateMethods)
+ (id)getTarget:(NSString *)path obj:(id)obj;
+ (BOOL)isDigit:(NSString *)text;
+ (NSString *)performAction:(id)action target:(id)target;
+ (NSString *)performMethod:(id)target methodName:(NSString *)methodName args:(id)args;
+ (NSString *)performGetObject:(id)target;
+ (NSString *)performSetValue:(id)target args:(id)args;
+ (NSString *)performValueForKey:(id)target args:(id)args;
+ (id)convertReturnValue:(void *)buffer returnType:(const char *)returnType;
+ (id)convertToValue:(NSDictionary *)dict;
+ (void)setArgument:(NSInvocation *)invocation index:(NSInteger)index argType:(const char *)argType arg:(id)arg;
+ (void)performInvocation:(NSDictionary *)dict;
@end


@implementation TurnipCommand


+ (NSString *)performWithObject:(NSMutableString *)request obj:(id)obj;
{
  id  req = [JsonUtils parseJson:request];
  id  target = [TurnipCommand getTarget:[req objectForKey:@"target"] obj:(id)obj];

  if (target == nil) {
    return @"invalid request\n";
  } else {
    return [TurnipCommand performAction:[req objectForKey:@"action"] target:target];
  }
}


+ (id)getTarget:(NSString *)path obj:(id)obj
{
  NSArray*  paths = [path componentsSeparatedByString:@"."];
  int count = (int)[paths count];

  if (count == 0) {
    return nil;
  }

  id  target = obj;

  if ([paths[0] isEqualToString:@""]) {
  } else {
    for (int i = 0; i < count; i++) {

      if ([TurnipCommand isDigit:paths[i]]) {
        int index = [paths[i] intValue];
        target = [target objectAtIndex:index];
      } else {

        NSString* propertyName = paths[i];
        objc_property_t property = class_getProperty([target class], [propertyName UTF8String]);

        if (property) {
          SEL _selector = NSSelectorFromString(propertyName);
          if ([target performSelector:_selector]) {
            target  = [target performSelector:_selector];
          } else {
            //NSLog(@"property target:%@", target);
          }
        } else {
          unsigned int      outCount = 0;
          Class             clazz = [target class];
          Ivar*             ivars = class_copyIvarList(clazz, &outCount);

          for (int j = 0; j < outCount; j++) {
            Ivar  ivar = ivars[j];
            const char* ivar_name = ivar_getName(ivar);
            NSString* name = [NSString stringWithCString:ivar_name encoding:NSUTF8StringEncoding]; 

            if ([name isEqualToString:paths[i]]) {
              id  objValue;
              object_getInstanceVariable(target, ivar_name, (void **)&objValue);
              if (!objValue) {
                return nil;
              } else {
                target = objValue;
                break;
              }
            }
          }
        }
      }
    }
  }

  return target;
}


+ (BOOL)isDigit:(NSString *)text
{
  NSCharacterSet *digitCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];

  NSScanner*  scanner = [NSScanner localizedScannerWithString:text];
  [scanner setCharactersToBeSkipped:nil];

  [scanner scanCharactersFromSet:digitCharSet intoString:NULL];
  return [scanner isAtEnd];
}


+ (NSString *)performAction:(id)action target:(id)target
{
  if ([[action objectForKey:@"type"] isEqualToString:@"method"]) {
    NSString* methodName = [action objectForKey:@"methodName"];
    id        args = [action objectForKey:@"args"];
    return [TurnipCommand performMethod:target methodName:methodName args:args];
  } else if ([[action objectForKey:@"type"] isEqualToString:@"getObject"]) {
    return [TurnipCommand performGetObject:target];
  } else if ([[action objectForKey:@"type"] isEqualToString:@"setValue"]) {
    id  args = [action objectForKey:@"args"];
    return [TurnipCommand performSetValue:target args:args];
  } else if ([[action objectForKey:@"type"] isEqualToString:@"valueForKey"]) {
    id  args = [action objectForKey:@"args"];
    return [TurnipCommand performValueForKey:target args:args];
  }

  return @"invalid request\n";
}


+ (NSString *)performMethod:(id)target methodName:(NSString *)methodName args:(id)args
{
  SEL _selector = NSSelectorFromString(methodName);

  if ([target respondsToSelector:_selector]) {
    NSMethodSignature*  signature = [target methodSignatureForSelector:_selector];
    int                 requiredNumberOfArguments = (int)(signature.numberOfArguments - 2);
    NSInvocation*       invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setSelector:_selector];

    if (requiredNumberOfArguments != 0) {
      if (requiredNumberOfArguments == [args count]) {
        NSInteger index = 2;
        //int count = 0;
        for ( id arg in args) {
	        const char* argType = [signature getArgumentTypeAtIndex:index];

          //NSLog(@"%d", count++);

          if( !strcmp(argType, @encode(id)) ) { // retval is an objective c object
            BOOL  flag = NO;
            if ([arg objectForKey:@"valueType"] != nil) {
              if ([[arg objectForKey:@"valueType"] isEqualToString:@"NSString"]) {
                //id value = [arg objectForKey:@"value"];
                NSString* value = (NSString *)[arg objectForKey:@"value"];
                //NSLog(@"%@", value);
                [invocation setArgument:&value atIndex:index];
                index++;
                flag = YES;
              }
            }

            if (!flag) {
              return @"invalid request perform method\n";
            }
          } else {
            [TurnipCommand setArgument:invocation index:index argType:argType arg:arg];
            index++;
          }
        }
      } 
    }

    NSDictionary* invDict = 
      [NSDictionary dictionaryWithObjectsAndKeys:target, @"target", invocation, @"invocation", nil];
    [TurnipCommand performSelectorOnMainThread:@selector(performInvocation:) withObject:invDict waitUntilDone:YES];

	  const char* returnType = signature.methodReturnType;
    NSDictionary* responseDic;

    if( !strcmp(returnType, @encode(void)) ) {
      responseDic = 
        [NSDictionary dictionaryWithObjectsAndKeys:
          @"nil", @"return", 
          methodName, @"methodName",
          @"method", @"type",
          nil
        ];
    } else if( !strcmp(returnType, @encode(id)) ) { // retval is an objective c object
	    id returnValue;

		  [invocation getReturnValue:&returnValue];
	
      responseDic =
	      [NSDictionary dictionaryWithObjectsAndKeys:
          returnValue, @"return", 
          methodName, @"methodName",
          @"method", @"type",
          nil
        ];

    } else {
		  NSUInteger length = [signature methodReturnLength];
		  void *buffer = (void *)malloc(length);
		  [invocation getReturnValue:buffer];

	    id  returnValue = 
        [TurnipCommand convertReturnValue:buffer returnType:(const char *)returnType];
		
      responseDic =
	      [NSDictionary dictionaryWithObjectsAndKeys:
          returnValue, @"return", 
          methodName, @"methodName",
          @"method", @"type",
          nil
        ];

      free(buffer);
    }

    NSString* json = [JsonUtils generateJson:responseDic];
    NSString* response = [NSString stringWithFormat:@"%@\n", json];

    return response;
  } else {
    return @"invalid request perform method because methodName is not exist\n";
  }
}


+ (NSString *)performGetObject:(id)target
{
  NSDictionary* responseDic;

  NSString* className = [NSString stringWithFormat:@"%s", class_getName([target class])];
  //unsigned int  outCount = 0;
  //Ivar* ivars = class_copyIvarList([target class], &outCount);
  //NSLog(@"ivars count:%d", outCount);

  responseDic = 
    [NSDictionary dictionaryWithObjectsAndKeys:
      className, @"return", 
      @"true", @"success", 
      @"getObject", @"type",
        nil
    ];

  NSString* json = [JsonUtils generateJson:responseDic];
  NSString* response = [NSString stringWithFormat:@"%@\n", json];

  return response;
}


+ (NSString *)performSetValue:(id)target args:(id)args
{
  SEL _selector = NSSelectorFromString(@"setValue:forKey:");
  NSMethodSignature*  signature = [target methodSignatureForSelector:_selector];
  NSInvocation*       invocation = [NSInvocation invocationWithMethodSignature:signature];

  NSInteger index = 2;
  id        argValue;
  id        value;

  [invocation setSelector:_selector];

  NSArray*      array = (NSArray *)args;
  NSDictionary* dict = [array objectAtIndex:0];

  value = [TurnipCommand convertToValue:dict];
  [invocation setArgument:&value atIndex:index++];

  argValue = [dict objectForKey:@"key"];
  [invocation setArgument:&argValue atIndex:index];

  NSDictionary* invDict = 
    [NSDictionary dictionaryWithObjectsAndKeys:target, @"target", invocation, @"invocation", nil];
  [TurnipCommand performSelectorOnMainThread:@selector(performInvocation:) withObject:invDict waitUntilDone:YES];

  NSDictionary* responseDic = 
    [NSDictionary dictionaryWithObjectsAndKeys:
      @"nil", @"return", 
      @"true", @"success", 
      @"setValue", @"type", 
      nil
    ];

  NSString* response = [JsonUtils generateJson:responseDic];

  return [NSMutableString stringWithFormat:@"%@\n", response];
}


+ (NSString *)performValueForKey:(id)target args:(id)args
{
  SEL _selector = NSSelectorFromString(@"valueForKey:");

  if ([target respondsToSelector:_selector]) {
    NSMethodSignature*  signature = [target methodSignatureForSelector:_selector];
    NSInvocation*       invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setSelector:_selector];

    NSArray*      array = (NSArray *)args;
    NSDictionary* dict = [array objectAtIndex:0];

    NSInteger index = 2;
    id argValue;

    argValue = [dict objectForKey:@"key"];
    [invocation setArgument:&argValue atIndex:index];
  
    NSDictionary* invDict = 
      [NSDictionary dictionaryWithObjectsAndKeys:target, @"target", invocation, @"invocation", nil];
    [TurnipCommand performSelectorOnMainThread:@selector(performInvocation:) withObject:invDict waitUntilDone:YES];
    id returnValue;
    [invocation getReturnValue:&returnValue];
  
    NSDictionary* responseDic = 
      [NSDictionary dictionaryWithObjectsAndKeys:
      returnValue, @"return", 
        @"true", @"success", 
        @"valueForKey", @"type", 
        nil
    ];
  
    NSString* response = [JsonUtils generateJson:responseDic];

    return [NSMutableString stringWithFormat:@"%@\n", response];
  } else {
    return @"invalid request\n";
  }
}


+ (id)convertReturnValue:(void *)buffer returnType:(const char *)returnType
{
  if (!strcmp(returnType, @encode(BOOL))) {
    return [NSNumber numberWithBool:*((BOOL *)buffer)];
  } else if (!strcmp(returnType, @encode(char))) {
    return [NSNumber numberWithChar:*((char *)buffer)];
  } else if (!strcmp(returnType, @encode(double))) {
    return [NSNumber numberWithDouble:*((double *)buffer)];
  } else if (!strcmp(returnType, @encode(float))) {
    return [NSNumber numberWithFloat:*((float *)buffer)];
  } else if (!strcmp(returnType, @encode(int))) {
    return [NSNumber numberWithInt:*((int *)buffer)];
  } else if (!strcmp(returnType, @encode(NSInteger))) {
    return [NSNumber numberWithInteger:*((NSInteger *)buffer)];
  } else if (!strcmp(returnType, @encode(long))) {
    return [NSNumber numberWithLong:*((long *)buffer)];
  } else if (!strcmp(returnType, @encode(long long))) {
    return [NSNumber numberWithLongLong:*((long long *)buffer)];
  } else if (!strcmp(returnType, @encode(short))) {
    return [NSNumber numberWithShort:*((short *)buffer)];
  } else if (!strcmp(returnType, @encode(unsigned char))) {
    return [NSNumber numberWithUnsignedChar:*((unsigned char *)buffer)];
  } else if (!strcmp(returnType, @encode(unsigned int))) {
    return [NSNumber numberWithUnsignedInt:*((unsigned int *)buffer)];
  } else if (!strcmp(returnType, @encode(NSUInteger))) {
    return [NSNumber numberWithInteger:*((NSUInteger *)buffer)];
  } else if (!strcmp(returnType, @encode(unsigned long))) {
    return [NSNumber numberWithUnsignedLong:*((unsigned long *)buffer)];
  } else if (!strcmp(returnType, @encode(unsigned long long))) {
    return [NSNumber numberWithUnsignedLongLong:*((unsigned long long *)buffer)];
  } else if (!strcmp(returnType, @encode(unsigned short))) {
    return [NSNumber numberWithUnsignedShort:*((unsigned short *)buffer)];
  } else {
    return [NSValue valueWithBytes:buffer objCType:returnType];
  }
}


+ (id)convertToValue:(NSDictionary *)dict
{
  if ([[dict objectForKey:@"valueType"] isEqualToString:@"BOOL"]) {
    if ([[dict objectForKey:@"value"] isEqualToString:@"YES"]) {
      return [NSNumber numberWithBool:YES];
    } else {
      return [NSNumber numberWithBool:NO];
    }
  } else if ([[dict objectForKey:@"valueType"] isEqualToString:@"double"]) {
    return [NSNumber numberWithDouble:[[dict objectForKey:@"value"] doubleValue]];
  } else if ([[dict objectForKey:@"valueType"] isEqualToString:@"int"]) {
    return [NSNumber numberWithInt:[[dict objectForKey:@"value"] intValue]];
  } else if ([[dict objectForKey:@"valueType"] isEqualToString:@"long"]) {
    return [NSNumber numberWithLong:[[dict objectForKey:@"value"] longValue]];
  } else {
    return nil;
  }  
}


+ (void)setArgument:(NSInvocation *)invocation index:(NSInteger)index argType:(const char *)argType arg:(id)arg
{
  if (!strcmp(argType, @encode(BOOL))) {
    BOOL value;
    if ([arg isEqualToString:@"YES"]) {
      value = YES;
    } else {
      value = NO;
    }
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(char))) {
    char  value = [arg charValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(double))) {
    double  value = [arg doubleValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(float))) {
    float value = [arg floatValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(int))) {
    int value = [arg intValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(NSInteger))) {
    NSInteger value = [arg intValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(long))) {
    long  value = [arg longValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(long long))) {
    long long value = [arg longLongValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(short))) {
    short value = [arg shortValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(unsigned char))) {
    unsigned char value = [arg unsignedCharValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(unsigned int))) {
    unsigned int  value = [arg unsignedIntValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(NSUInteger))) {
    NSUInteger  value = [arg unsignedIntValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(unsigned long))) {
    unsigned long  value = [arg unsignedLongValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(unsigned long long))) {
    unsigned long long  value = [arg unsignedLongLongValue];
    [invocation setArgument:&value atIndex:index];
  } else if (!strcmp(argType, @encode(unsigned short))) {
    unsigned short  value = [arg unsignedShortValue];
    [invocation setArgument:&value atIndex:index];
  } else {
    //return [NSValue valueWithBytes:buffer objCType:argType];
  }
}


+ (void)performInvocation:(NSDictionary *)dict
{
  id            target = [dict objectForKey:@"target"];
  NSInvocation* invocation = (NSInvocation *)[dict objectForKey:@"invocation"];
  [invocation invokeWithTarget:target];
}


@end

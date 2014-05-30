//
//  JsonUtils.h
//  ShumachTurnip
//
//  Created by shusaku FUKUMINE on 2014/03/08.
//  Copyright (c) 2014年 shusaku FUKUMINE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JsonUtils : NSObject


+ (id)parseJson:(NSString *)jsonStr;
+ (NSString *)generateJson:(id)obj;


@end

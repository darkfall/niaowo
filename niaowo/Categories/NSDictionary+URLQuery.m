//
//  NSDictionary+URLQuery.m
//  niaokula
//
//  Created by he on 12-10-30.
//  Copyright (c) 2012年 he. All rights reserved.
//

#import "NSDictionary+URLQuery.h"
#import "NSString+URLEncode.h"

@implementation NSDictionary (URLQuery)
- (NSString *)queryString
{
  NSMutableArray * parameterStrings = [NSMutableArray arrayWithCapacity:[self count]];
  for (NSString * key in self) {
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
      NSString * s = (NSString *)value;
      NSString * parameter;
      if ([s length] > 0) {//may be only a value, but no name/key
        parameter = [NSString stringWithFormat:@"%@=%@",
                     [key urlencodedString], [s urlencodedString]];
      }
      else {
        parameter = [key urlencodedString];
      }
      [parameterStrings addObject:parameter];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
      NSNumber * v = (NSNumber *)value;
      NSString * parameter = [NSString stringWithFormat:@"%@=%@",
                              [key urlencodedString], [[v stringValue] urlencodedString]];
      [parameterStrings addObject:parameter];
    }
    else if ([value isKindOfClass:[NSSet class]]) {
      NSArray * set = (NSArray *)value;
      NSString * encodedKey = [key urlencodedString];
      for (NSString * s in set) {
        NSString * parameter;
        if ([s length] > 0) {//may be only a value, but no name/key
          parameter = [NSString stringWithFormat:@"%@=%@",
                       encodedKey, [s urlencodedString]];
        }
        else {
          parameter = encodedKey;
        }
        [parameterStrings addObject:parameter];
      }
    }
  }
  if ([parameterStrings count]) {
    return [parameterStrings componentsJoinedByString:@"&"];
  }
  else {
    return @"";
  }
}
@end

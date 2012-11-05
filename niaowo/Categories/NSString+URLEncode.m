//
//  NSString+URLEncode.m
//  niaokula
//
//  Created by he on 12-10-30.
//  Copyright (c) 2012年 he. All rights reserved.
//

#import "NSString+URLEncode.h"

#define ESCAPE_CHARACTERS ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^`"   //RFC3986, '~' is an unreserved character ,should not be escaped

@implementation NSString (URLEncode)

- (NSString*)escapedString {
  NSString *newString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return newString?newString:@"";
}

- (NSString *)unescapeString {
  NSString *newString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  return newString?newString:@"";
}

- (NSString *)escapedStringWithoutWhitespace {
  NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, CFSTR(" "), CFSTR(ESCAPE_CHARACTERS), kCFStringEncodingUTF8);
	return newString?newString:@"";
}

- (NSString *)urlencodedString
{
#ifdef ESCAPE_WHITESPACE
  return [self escapedString];
#else
  NSString *newString = [self escapedStringWithoutWhitespace];
  newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  return newString;
#endif
}

- (NSString *)urldecodedString
{
  NSString * newString = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
  return [newString unescapeString];
}

@end

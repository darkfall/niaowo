//
//  NSString+URLEncode.h
//  niaokula
//
//  Created by he on 12-10-30.
//  Copyright (c) 2012年 he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)
- (NSString *)urlencodedString;
- (NSString *)urldecodedString;
@end

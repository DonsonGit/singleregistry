//
//  NSString+MD5.h
//  GTreatCH
//
//  Created by Rain on 13-11-11.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
// MD5 hash of the file on the filesystem specified by path
+ (NSString *) stringWithMD5OfFile: (NSString *) path;
// The string's MD5 hash
- (NSString *) MD5Hash;
- (BOOL)isLessToString:(NSString *)aString;

@end

//
//  NSString+Caculate.h
//  Project
//
//  Created by 橙子 on 2020/9/2.
//  Copyright © 2020 orange.ico. All rights reserved.
//
/*
   * 注意：1、该分类计算方式中，如果参数为空，会默认置为1；
               2、如果是除法，其分母为0，则返回0
*/

#import <Foundation/Foundation.h>


@interface NSString (Caculate)


/// 加法    例：2 + 3  = @“2”.add(@"3")
@property (nonatomic, copy) NSString *(^add)(NSString *str);


/// 减法    例：2 - 3  = @“2”.subtract(@"3")
@property (nonatomic, copy) NSString *(^subtract)(NSString *str);


/// 除法     例 ：2/3 = @“2”.dividing(@"3");
@property (nonatomic, copy) NSString *(^dividing)(NSString *str);


/// 乘法    例：2 * 3 = @“2”。multiply(@"3")
@property (nonatomic, copy) NSString *(^multiply)(NSString *str);


/// 幂运算  例：2^3  = @"2".power(@"3");
@property (nonatomic, copy) NSString *(^power)(NSString *str);


/// 末尾小数位补0
@property (nonatomic, copy) NSString *(^makeUpZeroAtLast)(NSInteger degit);


/// 向下保留小数位
@property (nonatomic, copy) NSString *(^saveNumberDown)(NSInteger degit);

@end



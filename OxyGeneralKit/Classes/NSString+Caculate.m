//
//  NSString+Caculate.m
//  Project
//
//  Created by 橙子 on 2020/9/2.
//  Copyright © 2020 orange.ico. All rights reserved.
//

#import "NSString+Caculate.h"
#import <objc/runtime.h>

@interface NSString()
@property (nonatomic, strong) NSDecimalNumber *decimalNumber;
@end

@implementation NSString (Caculate)
@dynamic add, subtract, dividing, multiply, power;
@dynamic makeUpZeroAtLast, saveNumberDown;

- (void)setDecimalNumber:(NSDecimalNumber *)decimalNumber{
    objc_setAssociatedObject(self, @selector(decimalNumber), decimalNumber, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDecimalNumber *)decimalNumber{
    if ([self isNumber] == NO) {
        return [NSDecimalNumber decimalNumberWithString:@"1"];
    }
    return [NSDecimalNumber decimalNumberWithString:self];
}

- (NSString *(^)(NSString *))add{
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
       return [weakSelf.decimalNumber decimalNumberByAdding:str.decimalNumber].stringValue;
    };
}

- (NSString *(^)(NSString *))subtract{
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        return [weakSelf.decimalNumber decimalNumberBySubtracting:str.decimalNumber].stringValue;
    };
}

- (NSString *(^)(NSString *))multiply{
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        return [weakSelf.decimalNumber decimalNumberByMultiplyingBy:str.decimalNumber].stringValue;
    };
}

- (NSString *(^)(NSString *))dividing{
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        if ([str.decimalNumber compare:@"0".decimalNumber] == NSOrderedSame) {
            return @"0";
        }
        return [weakSelf.decimalNumber decimalNumberByDividingBy:str.decimalNumber].stringValue;
    };
}

- (NSString *(^)(NSString *))power{
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        return [weakSelf.decimalNumber decimalNumberByRaisingToPower:str.integerValue].stringValue;
    };
}

- (NSString *(^)(NSInteger))makeUpZeroAtLast{
    __weak typeof(self) weakSelf = self;
    return ^(NSInteger degit){
        return [weakSelf makeUpZeroAtLastWithDegit:degit];
    };
}

- (NSString *(^)(NSInteger))saveNumberDown{
   __weak typeof(self) weakSelf = self;
    return ^(NSInteger degit){
        return [weakSelf numberSave:degit roundingMode:NSRoundDown];
    };
}

- (BOOL)isNumber{
    if (self == nil || [self length] <= 0){
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"-0123456789."] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![self isEqualToString:filtered]){
        return NO;
    }
    return YES;
}


- (NSString *)makeUpZeroAtLastWithDegit:(NSInteger)degit{
    if ([self containsString:@"."]) {//已有小数
        NSArray *arr = [self componentsSeparatedByString:@"."];
        if (arr.count >= 2) {
            if (degit == 0) {
                return arr[0];
            }
            NSInteger length = [[arr lastObject] length];
            if (length <= degit) {
                length = degit - length; // 需要补足的
                NSString *str = @"";
                for (NSInteger i=0; i<length; i++) {
                    str = [str stringByAppendingString:@"0"];
                }
                return [self stringByAppendingString:str];
            }else{//需要截取小数位
                NSString *str = [arr lastObject];
                str = [str substringWithRange:NSMakeRange(0, degit)];
                return [NSString stringWithFormat:@"%@.%@", arr[0], str];
            }
        }
        return self;
    }
    
    NSString *str = @"";
    for (NSInteger i=0; i<degit; i++) {
        if (i == 0) {
            str = [str stringByAppendingString:@".0"];
        }else{
            str = [str stringByAppendingString:@"0"];
        }
    }
    return [self stringByAppendingString:str];
}



- (NSString *)numberSave:(NSInteger) degit roundingMode:(NSRoundingMode)mode{
    NSString *single = @"";
    NSString *str = self;
    if ([self containsString:@"-"]) {
        single = @"-";
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                             scale:degit
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:NO];
    
    return [single stringByAppendingString:[str.decimalNumber decimalNumberByRoundingAccordingToBehavior:handler].stringValue];
}

@end

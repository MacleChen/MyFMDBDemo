//
//  User.h
//  MyFMDBDemo
//
//  Created by 陈帆 on 2019/11/7.
//  Copyright © 2019 陈帆. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSDecimalNumber *income;
@property (nonatomic) BOOL isMan;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *userIcon;

@end

NS_ASSUME_NONNULL_END

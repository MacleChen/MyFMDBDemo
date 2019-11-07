//
//  CZFFMDBExecute.h
//  MyFMDBDemo
//
//  Created by 陈帆 on 2019/11/7.
//  Copyright © 2019 陈帆. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class User;
@interface CZFFMDBExecute : NSObject

/// 单例
+ (instancetype)shareInstance;

/// 增加用户实体
/// @param user 用户对象
- (void)addUser:(User *)user;

/// 获取用户列表
- (NSArray<User *> *)getUserList;

/// 删除指定索引用户
/// @param userId 用户id
- (void)deleteUser:(NSString *)userId;

/// 删除所有用户
- (void)deleteAllUser;

/// 更新（修改）用户
/// @param user 用户对象
- (void)updateUser:(User *)user;

@end

NS_ASSUME_NONNULL_END

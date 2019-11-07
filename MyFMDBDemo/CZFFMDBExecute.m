//
//  CZFFMDBExecute.m
//  MyFMDBDemo
//
//  Created by 陈帆 on 2019/11/7.
//  Copyright © 2019 陈帆. All rights reserved.
//

#import "CZFFMDBExecute.h"
#import "User.h"

#define tableName @"User"

@interface CZFFMDBExecute()

/// 文件目录
@property(nonatomic, copy) NSString *documentDir;
@property(nonatomic, copy) FMDatabase *database;

@end

@implementation CZFFMDBExecute

/// 单例
+ (instancetype)shareInstance {
    static CZFFMDBExecute *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance =[[CZFFMDBExecute alloc] init];
    });
    
    return instance;
}

#pragma mark - Data base operate
- (NSString *)documentDir {
    if (!_documentDir) {
        _documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    return _documentDir;
}

- (FMDatabase *)database {
    if (!_database) {
        NSString *path = [self.documentDir stringByAppendingPathComponent:@"fmdb.db"];
        _database = [FMDatabase databaseWithPath:path];
        
        // create table
        if (![_database open]) {
            NSLog(@"database does not open.");
            return _database;
        }
        
        // 数据库中创建表（可创建多张）
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('userId' TEXT,'username' TEXT NOT NULL, 'userIcon' TEXT ,'age' INTEGER, 'createTime' INTEGER, 'income' REAL, 'isMan' INTEGER)", tableName];
        BOOL result = [_database executeUpdate:sql];
        if (result) {
            NSLog(@"create table success");
        }
        
        [_database close];
    }
    return _database;
}


/// 增加用户实体
/// @param user 用户对象
- (void)addUser:(User *)user {
    if (![self.database open]) {
        NSLog(@"database does not open.");
        return;
    }
    NSString *execSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@','%@',%d,%ld,%f,%d)", tableName, user.userId, user.username, user.userIcon, user.age, (NSInteger)[user.createTime timeIntervalSince1970], [user.income floatValue], user.isMan ? 1 : 0];
    BOOL result = [self.database executeUpdate:execSql];
    if (result) {
        NSLog(@"add user success");
    }
    
    [self.database close];
}


/// 获取用户列表
- (NSArray<User *> *)getUserList {
    if (![self.database open]) {
        NSLog(@"database does not open.");
        return NULL;
    }
    
    NSString *execSql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    FMResultSet *result = [self.database executeQuery:execSql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([result next]) {
        User *user = [User new];
        user.userId = [result stringForColumn:@"userId"];
        user.username = [result stringForColumn:@"username"];
        user.userIcon = [result stringForColumn:@"userIcon"];
        user.age = [result intForColumn:@"age"];
        user.createTime = [NSDate dateWithTimeIntervalSince1970:[result longForColumn:@"createTime"]];
        user.income = [[NSDecimalNumber alloc] initWithFloat:[result doubleForColumn:@"income"]];
        user.isMan = [result intForColumn:@"isMan"] == 0 ? NO : YES;
        [arr addObject:user];
    }
    
    [self.database close];
    
    return arr;
}

/// 删除指定索引用户
/// @param userId 用户id
- (void)deleteUser:(NSString *)userId {
    if (![self.database open]) {
        NSLog(@"database does not open.");
        return;
    }
    NSString *execSql = [NSString stringWithFormat:@"delete from %@ where userId = '%@'", tableName, userId];
    BOOL result = [self.database executeUpdate:execSql];
    if (result) {
        NSLog(@"delete user success");
    }
    
    [self.database close];
}

/// 删除所有用户
- (void)deleteAllUser {
    if (![self.database open]) {
        NSLog(@"database does not open.");
        return;
    }
    NSString *execSql = [NSString stringWithFormat:@"delete from %@", tableName];
    BOOL result = [self.database executeUpdate:execSql];
    if (result) {
        NSLog(@"delete all user success");
    }
    
    [self.database close];
}

/// 更新（修改）用户
/// @param user 用户对象
- (void)updateUser:(User *)user {
    if (![self.database open]) {
        NSLog(@"database does not open.");
        return;
    }
    NSString *execSql = [NSString stringWithFormat:@"UPDATE %@ SET username = '%@', age = %d, isMan = %d WHERE userId = '%@'", tableName, user.username, user.age, user.isMan ? 1 : 0, user.userId];
    BOOL result = [self.database executeUpdate:execSql];
    if (result) {
        NSLog(@"update user success");
    }
    
    [self.database close];
}

@end

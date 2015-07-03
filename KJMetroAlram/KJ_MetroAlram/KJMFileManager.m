//
//  KJMFileManager.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 10. 31..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "KJMFileManager.h"

#define PLIST_FILE_NAME @"Settingtimers.plist"

@implementation KJMSettingObj
@end

@implementation KJMFileManager

+ (KJMFileManager*)shareInstance {
    
    static dispatch_once_t pred = 0;
    __strong static KJMFileManager *_instance = nil;
    
    dispatch_once(&pred, ^{
        _instance = [[KJMFileManager alloc] init];
        [_instance _init];
    });
    return _instance;
}

#pragma mark - Private
- (BOOL)_init {
    
    NSString *bundleHistoryFilePath = [[self _getBundle] stringByAppendingPathComponent:PLIST_FILE_NAME];
    
    
    NSString *documentHistoryFilePath = [[self _getDocumentPath] stringByAppendingPathComponent:PLIST_FILE_NAME];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentHistoryFilePath] == NO) {
        
        NSError *error;
        if([[NSFileManager defaultManager] copyItemAtPath:bundleHistoryFilePath toPath:documentHistoryFilePath error:&error] == NO){
            return NO;
        }
    }
    return YES;
}

- (NSString*)_getBundle {
    
    return [[NSBundle mainBundle] bundlePath];
}


- (NSString*)_getDocumentPath {
    
    NSArray *documentPathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [documentPathArr objectAtIndex:0];
}

- (NSDictionary*)getTimerSetting {
    
    NSString *documentHistoryFilePath = [[self _getDocumentPath] stringByAppendingPathComponent:PLIST_FILE_NAME];

    return [NSDictionary dictionaryWithContentsOfFile:documentHistoryFilePath];
}

- (BOOL)addNewSetting:(KJMSettingObj*)object {
    
    NSMutableDictionary *currentSettingDic = [[self getTimerSetting] mutableCopy];
    
    for (int i = 1; i< 4; i++) {
     
        NSString *key = [NSString stringWithFormat:@"%dst", i];
        NSDictionary *setting = [currentSettingDic objectForKey:key];
        
        if ([[setting objectForKey:@"title"] isEqualToString:@"未設定"]) {
            NSDictionary *setDic = @{@"title":(!object.title)?@"":object.title
                                     ,@"startSta":(!object.startSta)?@"":object.startSta
                                     ,@"endSta":(!object.endSta)?@"":object.endSta
                                     ,@"spentTime":(!object.spentTime)?@"":object.spentTime
                                     ,@"bellFileName":(!object.bellFileName)?@"":object.bellFileName
                                     ,@"color":(!object.colorIndex)?@"2":object.colorIndex};
            
            [currentSettingDic setObject:setDic forKey:key];
            NSString *documentHistoryFilePath = [[self _getDocumentPath] stringByAppendingPathComponent:PLIST_FILE_NAME];

            return [currentSettingDic writeToFile:documentHistoryFilePath atomically:YES];
        }
    }
    return NO;
}

- (BOOL)modifySetting:(KJMSettingObj*)object index:(int)index {
    
    if (index < 0 || index > 3) {
        return NO;
    }
    NSMutableDictionary *currentSettingDic = [[self getTimerSetting] mutableCopy];

    NSString *key = [NSString stringWithFormat:@"%dst", index];
    
    NSDictionary *setDic = @{@"title":object.title
                             ,@"startSta":object.startSta
                             ,@"endSta":object.endSta
                             ,@"spentTime":object.spentTime
                             ,@"bellFileName":object.bellFileName
                             ,@"color":object.colorIndex};
    
    [currentSettingDic setObject:setDic forKey:key];
    
    NSString *documentHistoryFilePath = [[self _getDocumentPath] stringByAppendingPathComponent:PLIST_FILE_NAME];

    return [currentSettingDic writeToFile:documentHistoryFilePath atomically:YES];
    
}

- (BOOL)resetSetting:(int)index {

    if (index < 0 || index > 3) {
        return NO;
    }

    NSMutableDictionary *currentSettingDic = [[self getTimerSetting] mutableCopy];

    NSString *key = [NSString stringWithFormat:@"%dst", index];
    
    NSDictionary *setDic = @{@"title":@"未設定"
                             ,@"startSta":@""
                             ,@"endSta":@""
                             ,@"spentTime":@"0"
                             ,@"bellFileName":@"電子音.mp3"
                             ,@"color":@"2"};
    
    [currentSettingDic setObject:setDic forKey:key];
    
    NSString *documentHistoryFilePath = [[self _getDocumentPath] stringByAppendingPathComponent:PLIST_FILE_NAME];

    return [currentSettingDic writeToFile:documentHistoryFilePath atomically:YES];

}

- (NSDictionary*)getSettingWithKey:(NSString*)key {
    
    if (!key || [key isEqualToString:@""]){
        return nil;
    }
    
    return [[self getTimerSetting] objectForKey:key];
}

@end

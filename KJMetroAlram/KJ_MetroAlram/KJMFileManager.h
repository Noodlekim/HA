//
//  KJMFileManager.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 10. 31..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KJMSettingObj;
@interface KJMFileManager : NSObject

+ (KJMFileManager*)shareInstance;

- (NSDictionary*)getTimerSetting;
- (BOOL)addNewSetting:(KJMSettingObj*)object;
- (BOOL)modifySetting:(KJMSettingObj*)object index:(int)index;
- (BOOL)resetSetting:(int)index;
- (NSDictionary*)getSettingWithKey:(NSString*)key;
@end

@interface KJMSettingObj : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *startSta;
@property (strong, nonatomic) NSString *endSta;
@property (strong, nonatomic) NSString *spentTime;
@property (strong, nonatomic) NSString *bellFileName;
@property (strong, nonatomic) NSString *colorIndex;
@end


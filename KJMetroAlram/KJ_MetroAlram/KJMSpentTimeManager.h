//
//  KJMSpentTimeManager.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 8..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJMSpentTimeManager : NSObject

+ (KJMSpentTimeManager*)shareInstance;
- (NSArray*)calculateSpentTime:(NSString*)startSta endSta:(NSString*)endSta;
@end

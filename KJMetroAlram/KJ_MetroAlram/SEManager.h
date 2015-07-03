//
//  SEManager.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014/10/29.
//  Copyright (c) 2014年 KimGiBong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface SEManager : NSObject {
    
    NSMutableArray *soundArray;
}
@property(nonatomic) float soundVolume;
@property (strong, nonatomic) NSArray *alramFileArr;
@property (strong, nonatomic) NSString *seletecAlramFileName;

+ (SEManager *)sharedManager;
- (void)playSound:(NSString *)soundName;

@end
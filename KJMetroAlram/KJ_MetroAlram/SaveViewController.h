//
//  SaveViewController.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014/10/28.
//  Copyright (c) 2014年 KimGiBong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveViewController : UIViewController

@property (nonatomic) NSArray *buttonColors;
@property (nonatomic) id settingParam;

+ (SaveViewController*)shareInstance;
@end


@interface EkiModoObj : NSObject
@property (strong, nonatomic) NSString *startSta;
@property (strong, nonatomic) NSString *endSta;
@property (strong, nonatomic) NSString *bellMusic;
@property (nonatomic) int spentTime;
@end

@interface InputModeObj : NSObject
@property (nonatomic) int spentTime;
@property (strong, nonatomic) NSString *bellMusic;
@end


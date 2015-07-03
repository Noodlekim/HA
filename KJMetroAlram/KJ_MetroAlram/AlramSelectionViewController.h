//
//  AlramSelectionViewController.h
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 10. 26..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "ViewController.h"

@interface AlramSelectionViewController : ViewController

+ (AlramSelectionViewController*)shareInstance;

@property (nonatomic) NSString *currentBellName;
@end

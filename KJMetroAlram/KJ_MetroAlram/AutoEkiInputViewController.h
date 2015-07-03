//
//  AutoEkiInputViewController.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 3..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EkiResultTableViewCell.h"

typedef void (^CompleteEkiName)(NSString* ekiName);
@interface AutoEkiInputViewController : UIViewController

+ (AutoEkiInputViewController*)shareInstance;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic, strong) CompleteEkiName completeEkiName;
@end

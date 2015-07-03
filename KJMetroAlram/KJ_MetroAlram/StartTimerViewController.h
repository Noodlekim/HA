//
//  StartTimerViewController.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 3..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
 
    TimerDigitModeFour = 10,
    TimerDigitModeFive
    
}TimerDigitMode;

@protocol StartTimerViewControllerDelegate;
@interface StartTimerViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) id <StartTimerViewControllerDelegate> delegate;
@property (nonatomic) int totalTime;
@property (nonatomic) int standardTime;
@property (nonatomic) NSString *bellName;
@property (weak, nonatomic) IBOutlet UIView *BottonView;

+ (StartTimerViewController*)shareInstance;
- (void)setStartTimer;
- (void)dismissStartTimerView;
- (void)setFrameBottom;
@end


@protocol StartTimerViewControllerDelegate <NSObject>

- (void)loadInfomationView;
- (void)loadInManualView;

@end
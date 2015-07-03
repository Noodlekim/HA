//
//  InputModeViewController.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 1..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputModeObj;
@protocol InputModeViewControllerDelegate;
@interface InputModeViewController : UIViewController

@property (assign, nonatomic) id <InputModeViewControllerDelegate> delegate;
@property (nonatomic) IBOutlet UILabel *bellLbl;

- (void)selectedBellSetting:(NSString*)selectedBellName;
@end

@protocol InputModeViewControllerDelegate <NSObject>
@required
- (void)changedInputModeView;
- (void)loadInfomation;
- (void)loadSettingMusciView;
- (void)loadSaveViewController:(InputModeObj*)settingParam;
- (void)loadStartTimerController:(int)totalTime bell:(NSString*)bellName ;
@end



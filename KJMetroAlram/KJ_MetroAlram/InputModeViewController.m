//
//  InputModeViewController.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 1..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "InputModeViewController.h"
#import "KJMFileManager.h"
#import "AlramSelectionViewController.h"
#import "SaveViewController.h"
#import "ManualViewController.h"

#define IS_4_INCH_LESS (CGRectGetHeight([[UIScreen mainScreen] bounds]) < 568)?YES:NO

#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])

#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])

@interface InputModeViewController ()
@property (nonatomic) NSMutableArray *timeSumArray;
@property (nonatomic) int totalTime;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *inputButtons;
@property (nonatomic) IBOutlet UIButton *changeModeButton;
@property (nonatomic) IBOutlet UIButton *okButton;
@property (nonatomic) KJMSettingObj *settingObject;
@property (weak, nonatomic) IBOutlet UIButton *bellEditButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *osirase;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation InputModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!self.timeSumArray) {
        self.timeSumArray = [NSMutableArray new];
    }

    [self _setBellLabelFrame];
    
    if (IS_4_INCH_LESS) {
        
        self.view.frame = [UIScreen mainScreen].bounds;
        
        CGRect f = self.headerView.frame;
        f.origin.y = 5.f;
        self.headerView.frame = f;
        
        f = self.middleView.frame;
        f.origin.x = (SCREEN_WIDTH - f.size.width)/2;
        f.origin.y = 32.f;
        self.middleView.frame = f;
        
        
        f = self.osirase.frame;
        f.origin.x = ([UIScreen mainScreen].bounds.size.width - f.size.width)/2;
        f.origin.y = 240.f;
        f.size = CGSizeMake(320.f, 70.f);
        self.osirase.frame = f;
        
        f = self.bottomView.frame;
        f.origin.y = 293.f;
        self.bottomView.frame = f;
        
        
    }


}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettedData:) name:@"SET_INPUT_MODE_DATA" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self _setBellLabelFrame];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification

- (void)loadSettedData:(NSNotification*)notification {
    
 
    NSDictionary *settedDataDic = notification.object;
    
    self.bellLbl.text = settedDataDic[@"bellFileName"];
    [self _setBellLabelFrame];
    
    [self _resetSpentTime];
    NSString *spendTimeStr = settedDataDic[@"spentTime"];
    self.totalTime = spendTimeStr.intValue;
    [self _checkAbleAlram];
    for (int i=0; i<spendTimeStr.length;i++){
        
        NSString *numStr = [spendTimeStr substringWithRange:NSMakeRange(spendTimeStr.length - i -1, 1)];
        NSString *tempNum = [NSString stringWithFormat:@"Num%@", numStr];
        [self.timeSumArray addObject:[NSNumber numberWithInt:numStr.intValue]];
        [((UIButton*)self.inputButtons[i]) setImage:[UIImage imageNamed:tempNum] forState:UIControlStateNormal];
    }
}

#pragma mark - Private

- (void)_setBellLabelFrame {

    CGSize size = [self.bellLbl.text sizeWithFont:self.bellLbl.font constrainedToSize:CGSizeMake(200.f, CGRectGetHeight(self.bellLbl.frame)) lineBreakMode:self.bellLbl.lineBreakMode];
    
    CGRect f = self.bellLbl.frame;
    f.size = size;
    f.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - size.width - CGRectGetWidth(self.bellEditButton.frame))/2;
    self.bellLbl.frame = f;
    
    f = self.bellEditButton.frame;
    f.origin.x = CGRectGetMinX(self.bellLbl.frame) + CGRectGetWidth(self.bellLbl.frame);
    self.bellEditButton.frame = f;
    
}

- (void)_checkAbleAlram {
    
    self.okButton.selected = (self.totalTime>0);
}

- (void)_resetSpentTime {
    
    [self.timeSumArray removeAllObjects];
    self.totalTime = 0;
    [((UIButton*)self.inputButtons[0]) setImage:nil forState:UIControlStateNormal];
    [((UIButton*)self.inputButtons[1]) setImage:nil forState:UIControlStateNormal];
    [((UIButton*)self.inputButtons[2]) setImage:nil forState:UIControlStateNormal];
    
}

#pragma mark - Public
- (void)selectedBellSetting:(NSString*)selectedBellName {
    
    self.bellLbl.text = selectedBellName;
    self.settingObject.bellFileName = [selectedBellName stringByAppendingString:@".mp3"];
    
    [self _setBellLabelFrame];
}

#pragma mark - Action

- (IBAction)tappedClearButton:(id)sender {

    self.bellLbl.text = @"電子音";
    [self _setBellLabelFrame];
    [self _resetSpentTime];
    [self _checkAbleAlram];
}

- (IBAction)tappedInfomationButton:(id)sender {
 
    [self.delegate loadInfomation];
}
- (IBAction)tappedChangeMode:(id)sender {
    
    [self.delegate changedInputModeView];
}

- (IBAction)tappedKeyPadButton:(id)sender {
    
    NSString *totalTimeStr = @"";
    
    UIButton *keyPadButton = (UIButton*)sender;
    
    {
        keyPadButton.selected = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            keyPadButton.selected = NO;
        });
    }
    
    int tagNum = (int)keyPadButton.tag;
    if (!tagNum) {
        tagNum = 0;
    }
    if (tagNum < 10 && self.timeSumArray.count < 3) {
        [self.timeSumArray insertObject:[NSNumber numberWithInt:tagNum] atIndex:0];
    }
    else {
        [self tappedClearButton:nil];
    }
    
    for (int i=0; i<self.timeSumArray.count;i++){
        
        NSString *tempNum = [NSString stringWithFormat:@"Num%@.png", self.timeSumArray[i]];
        UIImage *numImage = [UIImage imageNamed:tempNum];
        [((UIButton*)self.inputButtons[i]) setImage:numImage forState:UIControlStateNormal];
        totalTimeStr = [NSString stringWithFormat:@"%@%@", self.timeSumArray[i], totalTimeStr];
    }
    
    if (![totalTimeStr isEqualToString:@""]) {
        self.totalTime = totalTimeStr.intValue;
    }
    [self _checkAbleAlram];
}

- (IBAction)tappedSettingAlramView:(id)sender {
    
    [self.delegate loadSettingMusciView];
}

- (IBAction)tappedManualButton:(id)sender {
    
    ManualViewController *vc = [[ManualViewController alloc] initWithNibName:@"ManualViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)tappedOKButton:(id)sender {
    
    if (self.totalTime == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"時間を入力してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    
    UIButton *button = (UIButton*)sender;
    if (!button.selected) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(loadStartTimerController:bell:)]) {
        [self.delegate loadStartTimerController:self.totalTime bell:self.bellLbl.text];
    }
}

- (IBAction)tappedSaveButton:(id)sender {
    
    InputModeObj *obj = [[InputModeObj alloc] init];
    obj.spentTime  = self.totalTime;
    obj.bellMusic = self.bellLbl.text;
    
    [self.delegate loadSaveViewController:obj];
    
}
@end

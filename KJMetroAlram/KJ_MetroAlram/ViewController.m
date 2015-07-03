
//  ViewController.m
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 10. 25..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "ViewController.h"

#import "AlramSelectionViewController.h"
#import "SaveViewController.h"
#import "KJMFileManager.h"
#import "AutoEkiInputViewController.h"
#import "KJMSpentTimeManager.h"
#import "ManualViewController.h"
#import "KJMLabel.h"

#define IS_4_INCH_LESS (CGRectGetHeight([[UIScreen mainScreen] bounds]) < 568)?YES:NO

#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])

#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])


@interface ViewController ()

@property (nonatomic) int totalTime;
@property (nonatomic) InputModeViewController *inputView;

@property (nonatomic) IBOutlet UIView *splashView;
@property (nonatomic) IBOutlet UIImageView *defaultView;
@property (nonatomic) IBOutlet UIImageView *turn_A_turnView;

@property (nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) IBOutlet UIView *ekiModeView;
@property (nonatomic) IBOutlet UIView *ekiInputView;

@property (nonatomic) IBOutlet UITextField *startTxf;
@property (nonatomic) IBOutlet UITextField *endTxf;
@property (nonatomic) IBOutlet UILabel *spentTimeLbl;
@property (nonatomic) IBOutletCollection(CustomBottomButton) NSArray *bottomButtons;

@property (weak, nonatomic) IBOutlet UIButton *bellEditButton;
@property (nonatomic) IBOutlet UILabel *bellLbl;
@property (nonatomic) IBOutlet UIButton *changeModeButton;
@property (nonatomic) IBOutlet UIButton *okButton;
@property (nonatomic) NSMutableDictionary *bottomSettings;
@property (nonatomic) KJMSettingObj *settingObject;

@property (weak, nonatomic) IBOutlet UIView *osirase;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet KJMLabel *osiraseLbl;
@property (weak, nonatomic) IBOutlet UIView *bottomMenuView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    {
        self.settingObject = [[KJMSettingObj alloc] init];
    }
    
    {
        self.inputView = [[InputModeViewController alloc] initWithNibName:@"InputModeViewController" bundle:nil];
        self.inputView.view.alpha = 0.f;
        self.inputView.delegate = self;
        [self addChildViewController:self.inputView];
        [self.contentView insertSubview:self.inputView.view atIndex:0];

    }
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedBellSetting:) name:@"SET_OVER_BELL" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_checkAbleAlram) name:UITextFieldTextDidChangeNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_setBottom) name:@"SAVED_SETTING" object:nil];
        
    }
    
    {
        [self _setBottom];
    }
    
    {
        for (UIButton *bottomButton in self.bottomButtons){
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressdBottomButton:)];
            longPress.minimumPressDuration = 1.5f;
            [bottomButton addGestureRecognizer:longPress];
            
        }
    }
    
    {
        [StartTimerViewController shareInstance];
    }
    
    {
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        if (systemVersion.integerValue >= 7) {
            NSLog(@"screen size: %@", NSStringFromCGRect(self.view.frame));
            self.splashView.frame = self.view.frame;
        }
    }
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];

//    [self _setBellLabelFrame];
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self _turnAturnAnimation];
//        [self _setBellLabelFrame];
    });

    {
        [KJMSpentTimeManager shareInstance];
    }
    
}

- (void)viewDidLayoutSubviews {

    if (IS_4_INCH_LESS) {
        
        self.view.frame = [UIScreen mainScreen].bounds;
        
        CGRect f = self.headerView.frame;
        f.origin.y = 5.f;
        self.headerView.frame = f;
        
        f = self.ekiInputView.frame;
        f.origin.x = (SCREEN_WIDTH - f.size.width)/2;
        f.origin.y = 32.f;
        self.ekiInputView.frame = f;
        
        
        f = self.osirase.frame;
        f.origin.x = ([UIScreen mainScreen].bounds.size.width - f.size.width)/2;
        f.origin.y = 240.f;
        f.size = CGSizeMake(320.f, 70.f);
        self.osirase.frame = f;
        
        f = self.bottomView.frame;
        f.origin.y = 293.f;
        self.bottomView.frame = f;
        
        f = self.bottomMenuView.frame;
        f.origin.y = SCREEN_HEIGHT - f.size.height;
        f.size.height = 65.f;
        self.bottomMenuView.frame = f;
        
        f = self.defaultView.frame;
        f.origin.y = -80.f;
        self.defaultView.frame = f;
        
        f = self.turn_A_turnView.frame;
        f.origin.y = 197.f;
        self.turn_A_turnView.frame = f;
        
        [self _setBellLabelFrame];
    }

}

- (void)_turnAturnAnimation{

    self.turn_A_turnView.transform = CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:0.65f animations:^{
        self.turn_A_turnView.transform = CGAffineTransformMakeRotation(2*M_PI*180/360.0-0.000001);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.45f delay:0.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.defaultView.alpha = 0.0f;
            self.splashView.alpha = 0.0f;
            
        } completion:nil];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification 
- (void)selectedBellSetting:(NSNotification*)notification {

    NSString *selectedBellName = notification.object;

    // 벨소리 선택되어서 로드 되게
    if (self.ekiModeView.alpha == 1.f) {
        
        self.bellLbl.text = selectedBellName;
        self.settingObject.bellFileName = [selectedBellName stringByAppendingString:@".mp3"];
        [self _setBellLabelFrame];
    }
    else {
        [self.inputView selectedBellSetting:selectedBellName];
        
    }
}

#pragma mark - Gesture Action
- (void)longPressdBottomButton:(UIGestureRecognizer *)gesture {
    
    NSLog(@"longPressdBottomButton: %@",gesture);
}

#pragma mark - Private
- (void)_setBottom {
    
    /*
     title
     startSta
     endSta
     bellFileName
     index
     */
    NSDictionary *allSetting = [[KJMFileManager shareInstance] getTimerSetting];
    
    if (!allSetting || ![allSetting isKindOfClass:[NSDictionary class]]){
        
        return;
    }
    
    {
        if (!self.bottomSettings) {
            
            self.bottomSettings = [NSMutableDictionary new];
        }
        else {
            [self.bottomSettings removeAllObjects];
        }
    }
    
    
    for (int i=0;i<3;i++) {
        NSString *key = [NSString stringWithFormat:@"%dst", i+1];
        NSDictionary *settingDic = [allSetting objectForKey:key];
        if (!settingDic) {
            continue;
        }
        [self.bottomSettings setDictionary:settingDic];
        
        CustomBottomButton *bottomButton = self.bottomButtons[i];
        if (!bottomButton) {
            continue;
        }
        
        NSString *title = [settingDic objectForKey:@"title"];
        bottomButton.titleLbl.text = title;
        
        if (![title isEqualToString:@"未設定"]){
            NSString *index = [settingDic objectForKey:@"color"];
            UIColor *color = [SaveViewController shareInstance].buttonColors[index.integerValue];
            
            if (color) {
                bottomButton.contentView.backgroundColor = color;
            }
        }
        else {
            UIColor *color = [SaveViewController shareInstance].buttonColors[2];
            
            if (color) {
                bottomButton.contentView.backgroundColor = color;
            }
        }
    }
}

- (void)_resetSpentTime {
    
    self.startTxf.text = @"";
    self.endTxf.text = @"";
    self.bellLbl.text = @"電子音";
    self.spentTimeLbl.text = @"所用時間目安：--分";
    [self _setBellLabelFrame];
}

- (void)_setBellLabelFrame {
    
    CGSize size = [self.bellLbl.text sizeWithFont:self.bellLbl.font constrainedToSize:CGSizeMake(200.f, CGRectGetHeight(self.bellLbl.frame)) lineBreakMode:self.bellLbl.lineBreakMode];
    
    CGRect f = self.bellLbl.frame;
    f.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - (size.width + self.bellEditButton.frame.size.width))/2;
    f.size = size;
    f.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - size.width - CGRectGetWidth(self.bellEditButton.frame))/2;
    self.bellLbl.frame = f;
    
    f = self.bellEditButton.frame;
    f.origin.x = CGRectGetMinX(self.bellLbl.frame) + CGRectGetWidth(self.bellLbl.frame);
    self.bellEditButton.frame = f;
    
}

- (void)_checkAbleAlram {

    NSLog(@"self.startTxf.text: %@", self.startTxf.text);
    self.okButton.selected = (![self.startTxf.text isEqualToString:@""] && ![self.endTxf.text isEqualToString:@""] && self.totalTime > 0);

}

- (BOOL)_checkInputValidation {
    
    NSString *startStr = self.startTxf.text;
    startStr = [startStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    startStr = [startStr stringByReplacingOccurrencesOfString:@"　" withString:@""];
    
    
    if (startStr.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"出発駅を入力してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    NSString *endStr = self.endTxf.text;
    endStr = [endStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    endStr = [endStr stringByReplacingOccurrencesOfString:@"　" withString:@""];
    
    
    if (endStr.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"到着駅を入力してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if (self.totalTime == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"時間の目安を\n取得できませんでした。\n「時間入力モード」で設定しますか？" delegate:self cancelButtonTitle:@"する" otherButtonTitles:@"しない", nil];
        [alert show];
        return NO;
    }

    
    return YES;
}

#pragma mark - Action
- (IBAction)tappedManualButton:(id)sender {
    
    ManualViewController *vc = [[ManualViewController alloc] initWithNibName:@"ManualViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)tappedChangeMode:(id)sender {

    self.ekiModeView.alpha = 0.f;
    self.inputView.view.alpha = 1.f;

    [UIView transitionWithView:self.contentView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{

                        [self.contentView bringSubviewToFront:self.inputView.view];
                        [self.contentView sendSubviewToBack:self.ekiModeView];
                        
                    }
                    completion:nil];

}

- (IBAction)tappedClearButton:(id)sender {
    [self _resetSpentTime];
    [self _checkAbleAlram];
}

- (IBAction)tappedSettingAlramView:(id)sender {
    
    [UIView animateWithDuration:0.25f animations:^{
        AlramSelectionViewController *vc = [AlramSelectionViewController shareInstance];
        
        // 벨소리 선택되어서 로드 되게
        if (self.ekiModeView.alpha == 1.f) {
            
            vc.currentBellName = [NSString stringWithFormat:@"%@.mp3", self.bellLbl.text];
        }
        else {
            
            vc.currentBellName = [NSString stringWithFormat:@"%@.mp3", self.inputView.bellLbl.text];
        }

        vc.view.alpha = 0.f;
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
        vc.view.alpha = 1.f;
        
    } completion:^(BOOL finished) {
        
    }];

}

- (IBAction)tappedOKButton:(id)sender {

    if (!self.okButton.selected) {
        
        if (![self _checkInputValidation]) {
            
            return;
        }
    }
    StartTimerViewController *vc = [StartTimerViewController shareInstance];
    vc.totalTime = self.totalTime;
    vc.standardTime = self.totalTime;
    vc.delegate = self;
    vc.bellName = [NSString stringWithFormat:@"%@.mp3", self.bellLbl.text];
    
    vc.view.alpha = 0.f;
    CGRect f = vc.view.frame;
    f.origin.y = - CGRectGetHeight([UIScreen mainScreen].bounds);
    vc.view.frame = f;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    [vc setFrameBottom];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        vc.view.alpha = 1.f;

        CGRect f = vc.view.frame;
        f.origin.y = 0.f;
        vc.view.frame = f;

    } completion:nil];


}

- (IBAction)tappedSaveButton:(id)sender {
    
    // 역 지정모드는 발리데이션 체크 넣어줌
    {
        if (![self _checkInputValidation]) {
            return;
        }
    }

    SaveViewController *vc = [SaveViewController shareInstance];
    EkiModoObj *obj = [[EkiModoObj alloc] init];
    obj.startSta = self.startTxf.text;
    obj.endSta = self.endTxf.text;
    obj.spentTime = self.totalTime;
    obj.bellMusic = self.bellLbl.text;
    
    vc.settingParam = obj;
    
    vc.view.alpha = 0.f;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    [UIView animateWithDuration:0.25f animations:^{
        vc.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)tappedBottmButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    int ButtonTag = (int)button.tag;
    
    NSString *key = [NSString stringWithFormat:@"%dst", ButtonTag];
    
    NSDictionary *settingDic = [[KJMFileManager shareInstance] getSettingWithKey:key];

    if (![settingDic[@"startSta"] isEqualToString:@""]) {
        
        if (self.ekiModeView.alpha != 1.f) {
            [self changedInputModeView];
        }
        self.settingObject.startSta = self.startTxf.text = settingDic[@"startSta"];
        self.settingObject.endSta =  self.endTxf.text = settingDic[@"endSta"];
        self.spentTimeLbl.text =  [NSString stringWithFormat:@"所用時間目安：%@分", settingDic[@"spentTime"]];
        self.settingObject.bellFileName = self.bellLbl.text = settingDic[@"bellFileName"];
        self.settingObject.title = settingDic[@"title"];
        self.settingObject.colorIndex = settingDic[@"color"];
    }
    else {
        
        if (self.inputView.view.alpha != 1.f) {
            [self tappedChangeMode:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_INPUT_MODE_DATA" object:settingDic];
    }
}

#pragma mark - StartTimerViewControllerDelegate
- (void)loadInfomationView {
    
    [self loadInfomation];
}

- (void)loadInManualView {
    
    [self tappedManualButton:nil];
}

#pragma mark - InputModeViewControllerDelegate

- (void)loadStartTimerController:(int)totalTime bell:(NSString*)bellName {

    StartTimerViewController *vc = [StartTimerViewController shareInstance];
    if (!vc) {
        return;
    }
    vc.totalTime = totalTime;
    vc.standardTime = totalTime;
    vc.bellName = [NSString stringWithFormat:@"%@.mp3", bellName];
    vc.delegate = self;
    
    vc.view.alpha = 0.f;
    CGRect f = vc.view.frame;
    f.origin.y = - CGRectGetHeight([UIScreen mainScreen].bounds);
    vc.view.frame = f;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];

    
    [UIView animateWithDuration:0.5f animations:^{
        
        [vc setFrameBottom];

        vc.view.alpha = 1.f;
        
        CGRect f = vc.view.frame;
        f.origin.y = 0.f;
        vc.view.frame = f;
        
    } completion:nil];
}

- (void)loadInfomation {
    
    [self performSegueWithIdentifier:@"LoadInfomationSegue" sender:self];
}

- (void)loadSettingMusciView {
    
    [self tappedSettingAlramView:nil];
}

- (void)changedInputModeView {


    self.ekiModeView.alpha = 1.f;
    self.inputView.view.alpha = 0.f;

    [UIView transitionWithView:self.contentView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        [self.contentView bringSubviewToFront:self.ekiModeView];
                        [self.contentView sendSubviewToBack:self.inputView.view];
                    }
                    completion:nil];
}

// 입력모드에서 나왔을 경우...
- (void)loadSaveViewController:(InputModeObj*)settingParam {
    
    SaveViewController *vc = [SaveViewController shareInstance];
    vc.settingParam = settingParam;
    
    vc.view.alpha = 0.f;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    
    [UIView animateWithDuration:0.25f animations:^{
        vc.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - CustomBottomButtonDelegate
- (void)tappedBottomButton:(CustomBottomButton*)button buttonMode:(ButtonMode)buttonMode {

    int ButtonTag = (int)button.tag;

    if (buttonMode == ButtonModeNormal) {
        
        
        NSString *key = [NSString stringWithFormat:@"%dst", ButtonTag+1];
        
        NSDictionary *settingDic = [[KJMFileManager shareInstance] getSettingWithKey:key];
        
        if (![settingDic[@"startSta"] isEqualToString:@""]) {
            
            if (self.ekiModeView.alpha != 1.f) {
                [self changedInputModeView];
            }
            self.settingObject.startSta = self.startTxf.text = settingDic[@"startSta"];
            self.settingObject.endSta =  self.endTxf.text = settingDic[@"endSta"];
            self.spentTimeLbl.text =  [NSString stringWithFormat:@"所用時間目安：%@分", settingDic[@"spentTime"]];
            self.settingObject.bellFileName = self.bellLbl.text = settingDic[@"bellFileName"];
            self.settingObject.title = settingDic[@"title"];
            self.settingObject.colorIndex = settingDic[@"color"];
            
            self.totalTime = ((NSString*)settingDic[@"spentTime"]).intValue;
            self.okButton.selected = (self.totalTime > 0);
        }
        else {
            
            if (self.inputView.view.alpha != 1.f) {
                [self tappedChangeMode:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_INPUT_MODE_DATA" object:settingDic];
        }

    }
    else {
        
        if([[KJMFileManager shareInstance] resetSetting:ButtonTag+1]) {
            
            [self _setBottom];
            
            button.buttonMode = ButtonModeNormal;
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self _resetSpentTime];
        [self tappedChangeMode:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    AutoEkiInputViewController *searchView = [AutoEkiInputViewController shareInstance];
    searchView.view.alpha = 0.f;
    
    NSString *placeHoler = @"";
    if (textField.tag == 100) {
        searchView.titleLbl.text = @"出発駅";
        placeHoler = @"出発駅を入力してください。";
    }
    else {
        searchView.titleLbl.text = @"到着駅";
        placeHoler = @"到着駅を入力してください。";
    }
    
    searchView.searchField.placeholder = placeHoler;
    
    [self.view addSubview:searchView.view];

    [UIView animateWithDuration:0.25f animations:^{
        
        searchView.view.alpha = 1.f;
        
    } completion:nil];

    searchView.completeEkiName = ^(NSString *ekiName){
     
        if (ekiName) {
            textField.text = ekiName;
            
            // 소요시간 체크
            {
                if ([self.startTxf.text isEqualToString:@""]){
                    return;
                }
                if ([self.endTxf.text isEqualToString:@""]){
                    return;
                }
                
                NSArray *spentTimeArr = [[KJMSpentTimeManager shareInstance] calculateSpentTime:self.startTxf.text endSta:self.endTxf.text];

                if (spentTimeArr.count > 0) {
                    self.totalTime = ((NSNumber*)spentTimeArr[0]).intValue;
                    
                    if (self.totalTime == 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"時間の目安を\n取得できませんでした。\n「時間入力モード」で設定しますか？" delegate:self cancelButtonTitle:@"する" otherButtonTitles:@"しない", nil];
                        [alert show];
                        return;
                    }

                    self.spentTimeLbl.text = [NSString stringWithFormat:@"所要時間目安：%d分", self.totalTime];
                    self.okButton.selected = (self.totalTime > 0);
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"時間の目安を\n取得できませんでした。\n「時間入力モード」で設定しますか？" delegate:self cancelButtonTitle:@"する" otherButtonTitles:@"しない", nil];
                    [alert show];
                }
            }

        }
    };
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {

    [self _checkAbleAlram];
    [textField resignFirstResponder];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}


@end

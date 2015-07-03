//
//  SaveViewController.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014/10/28.
//  Copyright (c) 2014年 KimGiBong. All rights reserved.
//

#import "SaveViewController.h"
#import "KJMFileManager.h"

#define RGB(r, g, b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define IS_4_INCH_LESS (CGRectGetHeight([[UIScreen mainScreen] bounds]) < 568)?YES:NO

#pragma mark - SaveObject
@implementation EkiModoObj

@end

@implementation InputModeObj

@end

@interface SaveViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutlet UITextField *settingTitleTxf;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray
*selectionButtons;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation SaveViewController

+ (SaveViewController*)shareInstance {
    
    static dispatch_once_t pred = 0;
    __strong static SaveViewController *_instance = nil;
    
    dispatch_once(&pred, ^{
        _instance = [[SaveViewController alloc] initWithNibName:@"SaveViewController" bundle:nil];
        [_instance _init];
    });
    return _instance;
}

- (void)_init {
    
    self.buttonColors = @[RGB(246, 170, 0)
                          , RGB(232, 55, 13)
                          , RGB(185, 185, 186)
                          , RGB(0, 184, 239)
                          , RGB(0, 152, 67)
                          , RGB(213, 147, 0)
                          , RGB(165, 73, 156)
                          , RGB(0, 176, 168)
                          , RGB(170, 89, 35)];

    {
        for (UIButton *btn in self.selectionButtons){
            
            btn.selected = NO;
            btn.exclusiveTouch = YES;
        }
        
        self.settingTitleTxf.text = @"";        
    }
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self _init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {


    if (IS_4_INCH_LESS) {

        CGRect f = self.titleLbl.frame;
        f.origin.y = 10.f;
        self.titleLbl.frame = f;
        
        f = self.inputView.frame;
        f.origin.y = CGRectGetMinY(self.titleLbl.frame) + CGRectGetHeight(self.titleLbl.frame) - 5.f;
        self.inputView.frame = f;
        
        f = self.selectionView.frame;
        f.origin.y = CGRectGetMidY(self.inputView.frame) + CGRectGetHeight(self.inputView.frame) - 17.f;
        self.selectionView.frame = f;
        
        f = self.bottomView.frame;
        f.origin.y = CGRectGetHeight([[UIScreen mainScreen] bounds]) - f.size.height;
        self.bottomView.frame = f;
    }
}

#pragma mark - Private

- (void)_resetSelected:(UIButton*)selectedButton {
    
    for (UIButton *button in self.selectionButtons) {
        
        if (button != selectedButton) {
            button.selected = NO;
        }
    }
}

#pragma mark - Action
- (IBAction)tappedColorButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    [UIView animateWithDuration:0.3f animations:^{
        button.selected = !button.selected;
        [self _resetSelected:button];
    } completion:nil];
}
- (IBAction)tappedBackButton:(id)sender {
    
    [UIView animateWithDuration:0.25f animations:^{

        self.view.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];

    }];
}

- (IBAction)tappedOKButton:(UIButton*)sender {
    
    NSString *title = self.settingTitleTxf.text;
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    title = [title stringByReplacingOccurrencesOfString:@"　" withString:@""];
    
    if (title.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"タイトルを入力してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIButton *selectedButton = nil;
    for (UIButton *btn in self.selectionButtons) {
        
        if (btn.selected) {
            selectedButton = btn;
            break;
        }
    }
    
    if (selectedButton) {

        KJMSettingObj *obj = [[KJMSettingObj alloc] init];
        obj.title = self.settingTitleTxf.text;
        obj.colorIndex = [NSString stringWithFormat:@"%ld", (long)selectedButton.tag];

        
        {
            if ([self.settingParam isKindOfClass:[InputModeObj class]]) {

                InputModeObj *inputModeObj = (InputModeObj*)self.settingParam;
                obj.spentTime = [NSString stringWithFormat:@"%d", inputModeObj.spentTime];
                obj.bellFileName = inputModeObj.bellMusic;
                
            }
            else if ([self.settingParam isKindOfClass:[EkiModoObj class]]) {
                EkiModoObj *ekiModoObj = (EkiModoObj*)self.settingParam;

                obj.startSta = ekiModoObj.startSta;
                obj.endSta = ekiModoObj.endSta;
                obj.spentTime = [NSString stringWithFormat:@"%d", ekiModoObj.spentTime];
                obj.bellFileName = ekiModoObj.bellMusic;
                
            }
            
            if ([[KJMFileManager shareInstance] addNewSetting:obj]) {
                [self tappedBackButton:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVED_SETTING" object:nil];
            }
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"色を選択してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [[textField.text stringByReplacingCharactersInRange:range withString:string] length] <= 5;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end

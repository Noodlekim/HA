//
//  StartTimerViewController.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 3..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "StartTimerViewController.h"

@interface StartTimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mongonLbl;
@property (weak, nonatomic) IBOutlet UILabel *timerLbl;
@property (nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *subWayView;
@property (weak, nonatomic) IBOutlet UIImageView *ballomImage;
@property (weak, nonatomic) IBOutlet UIImageView *subWayImage;
@property (weak, nonatomic) IBOutlet UIView *timerContainerView;
@property (strong, nonatomic) IBOutlet UIView *timerFourDigitView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timerFourDigits;

@property (strong, nonatomic) IBOutlet UIView *timerFiveDigitView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timerFiveDigits;
@property (nonatomic) NSString *totalTimeStr;
@property (nonatomic) NSString *currentTimeStr;
@property (nonatomic) NSDate *notificationDate;

@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;


@end

static NSArray *mongon = nil;
//static BOOL __isLoad = NO;
@implementation StartTimerViewController

+ (StartTimerViewController*)shareInstance {
    
    static dispatch_once_t pred = 0;
    __strong static StartTimerViewController *_instance = nil;
    
    dispatch_once(&pred, ^{
        _instance = [[StartTimerViewController alloc] init];
    });
    return _instance;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!mongon) {
        mongon = @[@"地下鉄や\nああ地下鉄や\n地下鉄や"
                   , @"野菜食べてる？"
                   , @"東京メトロは\n2014年で10周年！\nいやっほう"
                   , @"カロリーはウマい\nという名言"
                   , @"恐れず、怒らず\n悲しまず。\n─中村天風"
                   , @"しあわせは\nこころひとつの\nおきどころ\n─中村天風"
                   , @"おつかれさま！"
                   , @"チャンスは\n意外と\nすぐそこに…"
                   , @"十人十色って\nすばらしい"
                   , @"明日は\n明日の\n風が吹く～"
                   , @"最近\nいいこと\nあった？"
                   , @"人生は\n選択の連続！\n結果は今。"
                   , @"そろそろ\nシャンプーしたい\n（洗車の意）"
                   , @"かめはめ波って\nみんな一度は\n練習するよね"
                   , @"あしたって\n今さッ！"
                   ];
    }
    
    CGRect f = self.view.frame;
    f.size.height = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = f;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    {
        int randomIndex = arc4random() % 15;
        self.mongonLbl.text = mongon[randomIndex];
        
        [self setStartTimer];
    }
}

- (void)setFrameBottom {

    NSLog(@"size .>>>>>>>>: %@", NSStringFromCGSize(self.view.frame.size));
    CGRect f = self.BottonView.frame;
    f.origin.y = 0.f;
    f = self.BottonView.frame;
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.ballomImage.animationImages = @[[UIImage imageNamed:@"hukidasi01.png"]
                                        ,[UIImage imageNamed:@"hukidasi02.png"]
                                        , [UIImage imageNamed:@"hukidasi03.png"]
                                         , [UIImage imageNamed:@"hukidasi04.png"]];
    self.ballomImage.animationDuration = 1.f;
    self.ballomImage.animationRepeatCount = 0;
    
    [self.ballomImage startAnimating];
    
    self.subWayImage.animationImages = @[[UIImage imageNamed:@"subway01.png"]
                                         ,[UIImage imageNamed:@"subway02.png"]
                                         ,[UIImage imageNamed:@"subway03.png"]
                                         ,[UIImage imageNamed:@"subway04.png"]];
    self.subWayImage.animationDuration = 1.f;
    self.subWayImage.animationRepeatCount = 0;
    [self.subWayImage startAnimating];
    
    [self setFrameBottom];

}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];

    if (self.totalTimeStr) {
        return;
    }
    
    [self.ballomImage stopAnimating];
    [self.subWayImage stopAnimating];
    [self.timer invalidate];
    self.timer = nil;
    
    {
        CGRect f = self.subWayView.frame;
        f.origin.x = 0.f;
        self.subWayView.frame = f;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors
- (void)setTotalTimeStr:(NSString *)totalTimeStr {
    
    _totalTimeStr = totalTimeStr;
    
    NSArray *totalDigit = [_totalTimeStr componentsSeparatedByString:@":"];
    NSString *minutesStr = totalDigit[0];
    
    if (minutesStr.length > 2) {
        [self _changeTimerDigitMode:TimerDigitModeFive];
    }
    else {
        [self _changeTimerDigitMode:TimerDigitModeFour];
    }
    
}
#pragma mark - Public
- (void)setStartTimer {
    NSLog(@"parentViewController >>> %@", [self parentViewController]);
    
    if (![self parentViewController]) {
        return;
    }
    
    if (self.notificationDate) {

        NSTimeInterval passedTime = [[NSDate date] timeIntervalSinceDate:self.notificationDate];

        NSLog(@"passedTime %f", passedTime);

        int intPassed = [NSNumber numberWithDouble:passedTime].intValue;
        NSLog(@"intPassed: %d", intPassed);
        NSLog(@"spentTime %d", (self.standardTime * 60) + intPassed);
        self.totalTime = - intPassed;
        int minetue = self.totalTime/60+1;
        int sec = self.totalTime%60;
        NSLog(@" %d === %d", minetue, sec);

        if (intPassed > 0) {
            self.totalTimeStr = @"00:00";
            [self dismissStartTimerView];
        }
        
        if (minetue > 99) {
            self.totalTimeStr = [NSString stringWithFormat:@"%03d:%02d", minetue, sec];
        }
        else {
            self.totalTimeStr = [NSString stringWithFormat:@"%02d:%02d", minetue, sec];
        }
    }
    else {

        if (self.totalTime > 99) {
            self.totalTimeStr = [NSString stringWithFormat:@"%03d:00", self.totalTime];
        }
        else {
            self.totalTimeStr = [NSString stringWithFormat:@"%02d:00", self.totalTime];
        }
        
        {
            for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            NSDate *mydate = [NSDate date];
            NSTimeInterval seconds = (60 * self.totalTime);
            notif.fireDate = [mydate dateByAddingTimeInterval:seconds - 60];
            self.notificationDate = [mydate dateByAddingTimeInterval:seconds - 60];
            NSLog(@"notif.fireDate > %@", notif.fireDate);
            NSLog(@"self.notificationDate > %@", self.notificationDate);
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.alertBody = @" [HA!からのお知らせ]\nそろそろ着きそうです。";
            notif.soundName = (!self.bellName || [self.bellName isEqualToString:@""])?@"電子音.mp3":self.bellName;
            notif.userInfo = @{@"test":@"1"};
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            
        }

    }
    
    if (self.timer) {
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(_timer) userInfo:nil repeats:YES];
}

- (void)dismissStartTimerView {
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.alpha = 0.f;
        
        CGRect f = self.view.frame;
        f.origin.y = - f.size.height;
        self.view.frame = f;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self.timer invalidate];
        self.timer = nil;
        self.notificationDate = nil;
        
    }];
}

#pragma mark - Private

- (void)_changeTimerDigitMode:(TimerDigitMode)mode {
    
//    NSLog(@"===> timer > %@", _totalTimeStr);
    NSArray *totalDigit = [_totalTimeStr componentsSeparatedByString:@":"];
    NSString *minutesStr = totalDigit[0];
    NSString *secStr = totalDigit[1];
    
    switch (mode) {
        case TimerDigitModeFour:{
            
            {
                [self.timerContainerView bringSubviewToFront:self.timerFourDigitView];
                [self.timerContainerView sendSubviewToBack:self.timerFiveDigitView];
            }
            
            {
                NSString *firstDigit = [minutesStr substringWithRange:NSMakeRange(0, 1)];
                NSString *secondDigit = [minutesStr substringWithRange:NSMakeRange(1, 1)];
                
                firstDigit = [NSString stringWithFormat:@"Num%@.png", firstDigit];
                secondDigit = [NSString stringWithFormat:@"Num%@.png", secondDigit];
                [((UIButton*)self.timerFourDigits[0]) setImage:[UIImage imageNamed:firstDigit] forState:UIControlStateNormal];
                [((UIButton*)self.timerFourDigits[1]) setImage:[UIImage imageNamed:secondDigit] forState:UIControlStateNormal];
                
                NSString *thridDigit = [secStr substringWithRange:NSMakeRange(0, 1)];
                NSString *fourthDigit = [secStr substringWithRange:NSMakeRange(1, 1)];
                
                thridDigit = [NSString stringWithFormat:@"Num%@.png", thridDigit];
                fourthDigit = [NSString stringWithFormat:@"Num%@.png", fourthDigit];
                [((UIButton*)self.timerFourDigits[2]) setImage:[UIImage imageNamed:thridDigit] forState:UIControlStateNormal];
                [((UIButton*)self.timerFourDigits[3]) setImage:[UIImage imageNamed:fourthDigit] forState:UIControlStateNormal];
            }
            break;
        }
        case TimerDigitModeFive:{
            
            {
                [self.timerContainerView bringSubviewToFront:self.timerFiveDigitView];
                [self.timerContainerView sendSubviewToBack:self.timerFourDigitView];
            }
            
            {
                NSString *firstDigit = [minutesStr substringWithRange:NSMakeRange(0, 1)];
                NSString *secondDigit = [minutesStr substringWithRange:NSMakeRange(1, 1)];
                NSString *thirdDigit = [minutesStr substringWithRange:NSMakeRange(2, 1)];
                
                firstDigit = [NSString stringWithFormat:@"Num%@.png", firstDigit];
                secondDigit = [NSString stringWithFormat:@"Num%@.png", secondDigit];
                thirdDigit = [NSString stringWithFormat:@"Num%@.png", thirdDigit];

                [((UIButton*)self.timerFiveDigits[0]) setImage:[UIImage imageNamed:firstDigit] forState:UIControlStateNormal];
                [((UIButton*)self.timerFiveDigits[1]) setImage:[UIImage imageNamed:secondDigit] forState:UIControlStateNormal];
                [((UIButton*)self.timerFiveDigits[2]) setImage:[UIImage imageNamed:thirdDigit] forState:UIControlStateNormal];
                
                NSString *fourthDigit = [secStr substringWithRange:NSMakeRange(0, 1)];
                NSString *fifthDigit = [secStr substringWithRange:NSMakeRange(1, 1)];
                
                fourthDigit = [NSString stringWithFormat:@"Num%@.png", fourthDigit];
                fifthDigit = [NSString stringWithFormat:@"Num%@.png", fifthDigit];

                [((UIButton*)self.timerFiveDigits[3]) setImage:[UIImage imageNamed:fourthDigit] forState:UIControlStateNormal];
                [((UIButton*)self.timerFiveDigits[4]) setImage:[UIImage imageNamed:fifthDigit] forState:UIControlStateNormal];
            }
            break;
        }
    }
}

- (void)_timer {
    
    NSArray *timeArr = [self.totalTimeStr componentsSeparatedByString:@":"];
    int minutes = ((NSString*)timeArr[0]).intValue;
    int sec = ((NSString*)timeArr[1]).intValue;
    
    sec--;
//    self.totalTime = minutes *60 + sec;
    
    if (minutes == 0 && sec == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.totalTimeStr = @"00:00";
        [self dismissStartTimerView];
        self.totalTimeStr = nil;
    }

    
    if (sec <= 0) {
        sec = 59;
        minutes--;
        if (minutes < 0) {
            
            [self.timer invalidate];
            self.timer = nil;
            return;

        }
    }
//    NSLog(@"--------------- minutes > %d", minutes);
    if (minutes < 100) {
        self.totalTimeStr = [NSString stringWithFormat:@"%02d:%02d", minutes, sec];
    }
    else {
        self.totalTimeStr = [NSString stringWithFormat:@"%03d:%02d", minutes, sec];
    }
    
    {
        // 전차 애니메이션 효과
     
        // 시작점 : x = 0 ~ 134.f 4인치 기준
        // 6+에서 어떻게 나오는지 확인 필요.
        // 현재 진행길이 = (경과시간 * 전체길이)/전체시간
        float currentX = ((minutes*60 + sec) * 168.f)/(self.standardTime * 60);

        CGRect f = self.subWayView.frame;
        f.origin.x = 168.f - currentX;
        self.subWayView.frame = f;
    }
}

- (void)_dismissLocalNotification {
    
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}

#pragma mark - Action
- (IBAction)tappedStopButton:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"アラームを解除しますか？" delegate:self cancelButtonTitle:@"する" otherButtonTitles:@"しない", nil];
    [alert show];
}

- (IBAction)tappedInfomationButton:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(loadInfomationView)]) {
        
        [self.delegate loadInfomationView];
    }
}
- (IBAction)tappedManualButton:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(loadInManualView)]) {
        
        [self.delegate loadInManualView];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [UIView animateWithDuration:0.5f animations:^{
            self.view.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            [self.timer invalidate];
            self.notificationDate = nil;
            self.timer = nil;
            self.totalTimeStr = nil;
            
            [self _dismissLocalNotification];
        }];

    }
}
@end
